import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../data/models/medicine_model.dart';
import '../../data/models/dose_record_model.dart';
import 'local_storage_service.dart';
import '../../routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Background notification tap handler (called when app is terminated/background)
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MedicineAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(DoseRecordAdapter());
  }

  final box = await Hive.openBox<Medicine>('medicines');
  final doseBox = await Hive.openBox<DoseRecord>('dose_records');
  final logBox = await Hive.openBox('activity_logs');

  final payload = notificationResponse.payload;
  final actionId = notificationResponse.actionId;

  if (payload != null) {
    final now = DateTime.now();
    final timestampStr = now.toIso8601String();

    if (payload.startsWith('med_')) {
      final doseId = payload.substring(4); // strip 'med_' prefix
      final dose = doseBox.get(doseId);

      if (dose != null) {
        final dosageStr = dose.customDosage ?? '1 Dose';
        if (actionId == 'taken') {
          dose.status = 'taken';
          dose.takenTime = now;
          await dose.save();

          // Log medicine taken
          await logBox.add({
            'id': 'med_${dose.id}_$timestampStr',
            'type': 'medicine',
            'name': dose.medicineName ?? 'Medicine',
            'action': 'taken',
            'timestamp': timestampStr,
            'details': '$dosageStr • ${dose.mealRelation}',
          });

          // Reduce stock if tracking enabled
          final medicine = box.get(dose.medicineId);
          if (medicine != null && medicine.totalStock != null) {
            final dosage = medicine.dosage ?? 1;
            medicine.totalStock = (medicine.totalStock! - dosage).clamp(0, 99999);
            await medicine.save();

            // Low stock warning
            if (medicine.totalStock! <= (medicine.stockThreshold ?? 5)) {
              final localNotifications = FlutterLocalNotificationsPlugin();
              await localNotifications.show(
                id: medicine.id.hashCode + 999,
                title: '⚠️ Medicine Running Low',
                body: '${medicine.name} is running low! Only ${medicine.totalStock} left.',
                notificationDetails: const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'stock_alerts',
                    'Stock Alerts',
                    importance: Importance.high,
                    priority: Priority.high,
                  ),
                  iOS: DarwinNotificationDetails(),
                ),
              );
            }
          }

          // Update streak metrics
          final today = '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}';
          LocalStorage.saveMedicinesTakenCount(LocalStorage.getMedicinesTakenCount() + 1);

          final lastActive = LocalStorage.getLastActiveDate();
          if (lastActive != today) {
            if (lastActive.isNotEmpty) {
              final lastDate = DateTime.tryParse(lastActive.replaceAll('_', '-'));
              if (lastDate != null && now.difference(lastDate).inDays == 1) {
                LocalStorage.saveMedicineStreak(LocalStorage.getMedicineStreak() + 1);
              } else {
                LocalStorage.saveMedicineStreak(1);
              }
            } else {
              LocalStorage.saveMedicineStreak(1);
            }
            LocalStorage.saveLastActiveDate(today);
          }

        } else if (actionId == 'skip') {
          dose.status = 'skipped';
          await dose.save();

          await logBox.add({
            'id': 'med_${dose.id}_$timestampStr',
            'type': 'medicine',
            'name': dose.medicineName ?? 'Medicine',
            'action': 'skipped',
            'timestamp': timestampStr,
            'details': '$dosageStr • ${dose.mealRelation}',
          });
        }
      }
    } else if (payload.startsWith('water_')) {
      if (actionId != null && actionId.startsWith('water_add_')) {
        final amount = int.tryParse(actionId.split('_')[2]) ?? 250;
        final dateKey = '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}';

        final list = LocalStorage.getWaterLogs(dateKey);
        final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        list.insert(0, {'time': timeStr, 'amount': amount});
        await LocalStorage.saveWaterLogs(dateKey, list);

        final currentGlasses = LocalStorage.getWaterGlassesCount();
        LocalStorage.saveWaterGlassesCount(currentGlasses + (amount / 250).round());

        await logBox.add({
          'id': 'water_$timestampStr',
          'type': 'water',
          'name': 'Water Intake',
          'action': 'water_logged',
          'timestamp': timestampStr,
          'details': '+$amount ml',
        });

        // Reschedule remaining water reminders for today
        final target = LocalStorage.getWaterTarget();
        final currentTotal = list.fold<double>(0, (sum, item) => sum + (item['amount'] as num).toDouble());
        if (LocalStorage.isWaterSmartStopEnabled() && currentTotal >= target) {
          await NotificationService.cancelWaterReminders();
        } else {
          await NotificationService.rescheduleWaterReminders(currentTotal, target);
        }
      } else if (actionId == 'water_dismiss') {
        await logBox.add({
          'id': 'water_dismiss_$timestampStr',
          'type': 'water',
          'name': 'Water Intake',
          'action': 'dismissed',
          'timestamp': timestampStr,
          'details': 'Dismissed hydration reminder',
        });
      }
    }
  }

  // Cancel the specific notification that was acted upon
  if (notificationResponse.id != null) {
    final localNotifications = FlutterLocalNotificationsPlugin();
    await localNotifications.cancel(id: notificationResponse.id!);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NotificationService
// ─────────────────────────────────────────────────────────────────────────────
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Maximum water reminder slots per day (8am–10pm every 30 min = 56 max)
  static const int _maxWaterSlots = 60;

  // ─── Initialization ────────────────────────────────────────────────────────

  static Future<void> init() async {
    // Step 1: Initialize timezone database
    tz.initializeTimeZones();

    // Step 2: Detect real device IANA timezone via flutter_timezone
    await _initializeTimezone();

    // Step 3: Initialize the notifications plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Foreground handler
        if (response.payload != null) {
          final payload = response.payload!;
          final actionId = response.actionId;

          if (payload.startsWith('med_')) {
            final doseId = payload.substring(4); // strip 'med_' prefix
            if (actionId == 'snooze' || actionId == null) {
              // Tap or snooze → open full-screen alarm
              Get.toNamed(Routes.fullScreenAlarm, arguments: doseId);
            }
            // 'taken' and 'skip' are handled by notificationTapBackground too
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Step 4: Create all notification channels (Android only, do this once)
    await _createNotificationChannels();
  }

  /// Detects the real device IANA timezone using flutter_timezone.
  /// Falls back to UTC if detection fails.
  static Future<void> _initializeTimezone() async {
    try {
      final String timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      // Fallback: try offset-based detection
      _setLocalTimezoneByOffset();
    }
  }

  /// Offset-based fallback when flutter_timezone fails.
  static void _setLocalTimezoneByOffset() {
    try {
      final offsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
      const tzMap = {
        360: 'Asia/Dhaka',       // UTC+6
        330: 'Asia/Kolkata',     // UTC+5:30
        300: 'Asia/Karachi',     // UTC+5
        345: 'Asia/Kathmandu',   // UTC+5:45
        420: 'Asia/Bangkok',     // UTC+7
        480: 'Asia/Shanghai',    // UTC+8
        540: 'Asia/Tokyo',       // UTC+9
        -300: 'America/New_York',
        -360: 'America/Chicago',
        -420: 'America/Denver',
        -480: 'America/Los_Angeles',
        0: 'Europe/London',
        60: 'Europe/Paris',
        120: 'Europe/Helsinki',
        180: 'Asia/Riyadh',
        240: 'Asia/Dubai',
      };
      final ianaName = tzMap[offsetMinutes] ?? 'UTC';
      tz.setLocalLocation(tz.getLocation(ianaName));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  /// Creates all required notification channels. Called once during init().
  static Future<void> _createNotificationChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    // Medicine channels
    await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
      'medicine_default',
      'Medicine Alarms',
      description: 'Medicine reminders using default alarm sound',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    ));
    await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
      'medicine_custom',
      'Medicine Alarms (Custom Sound)',
      description: 'Medicine reminders using custom sound',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      enableVibration: true,
      showBadge: true,
    ));
    await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
      'medicine_silent',
      'Medicine Alarms (Silent)',
      description: 'Silent medicine reminders',
      importance: Importance.high,
      playSound: false,
      enableVibration: false,
      showBadge: true,
    ));
    await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
      'medicine_vibrate',
      'Medicine Alarms (Vibrate Only)',
      description: 'Vibration-only medicine reminders',
      importance: Importance.high,
      playSound: false,
      enableVibration: true,
      showBadge: true,
    ));

    // Water reminder channel
    await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
      'water_reminders',
      'Water Reminders',
      description: 'Periodic reminders to drink water and stay hydrated',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    ));

    // Stock alert channel
    await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
      'stock_alerts',
      'Medicine Stock Alerts',
      description: 'Alerts when medicine stock is running low',
      importance: Importance.high,
      playSound: true,
      enableVibration: false,
      showBadge: true,
    ));
  }

  // ─── Permission Requests ───────────────────────────────────────────────────

  /// Returns true if SCHEDULE_EXACT_ALARM is granted (Android 12+) or not needed.
  static Future<bool> _canUseExactAlarms() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  /// Returns Android SDK version, or 0 on non-Android / failure.
  static Future<int> _getAndroidSdkVersion() async {
    if (!Platform.isAndroid) return 0;
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    } catch (_) {
      return 0;
    }
  }

  /// Shows the permission explanation dialog once per install.
  /// Requests POST_NOTIFICATIONS (Android 13+) and SCHEDULE_EXACT_ALARM (Android 12+).
  static Future<void> requestPermissionsWithConfirmation() async {
    final hasRequested = GetStorage().read<bool>('permissions_requested') ?? false;

    if (hasRequested) {
      // On subsequent launches, silently re-request exact alarm if still missing
      if (Platform.isAndroid) {
        final canExact = await _canUseExactAlarms();
        if (!canExact) {
          final androidPlugin = _notificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
          await androidPlugin?.requestExactAlarmsPermission();
        }
      }
      return;
    }

    await GetStorage().write('permissions_requested', true);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 28),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Enable Medicine Alarms',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ShifaTime needs two permissions to deliver reliable medicine and hydration alarms — even when the app is closed or the screen is locked:',
              style: GoogleFonts.outfit(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 12),
            _permissionRow(Icons.notifications_rounded, 'Notifications', 'Show medicine & water reminders'),
            const SizedBox(height: 8),
            _permissionRow(Icons.alarm_rounded, 'Exact Alarms', 'Fire at the exact scheduled minute'),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Skip',
              style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _grantPermissions();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Allow Permissions',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> _grantPermissions() async {
    if (Platform.isAndroid) {
      final sdkVersion = await _getAndroidSdkVersion();

      // Android 13+ (API 33+): POST_NOTIFICATIONS runtime permission
      if (sdkVersion >= 33) {
        final status = await Permission.notification.request();
        if (status.isPermanentlyDenied) {
          await openAppSettings();
          return;
        }
      }

      // Android 12+ (API 31+): SCHEDULE_EXACT_ALARM — opens system settings
      if (sdkVersion >= 31) {
        final canExact = await _canUseExactAlarms();
        if (!canExact) {
          final androidPlugin = _notificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
          await androidPlugin?.requestExactAlarmsPermission();
        }
      }
    } else if (Platform.isIOS) {
      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: false,
      );
    }
  }

  static Widget _permissionRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(subtitle, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // ─── Medicine Notifications ────────────────────────────────────────────────

  /// Schedules a single medicine notification using zonedSchedule + AlarmManager.
  /// Falls back to inexact scheduling if SCHEDULE_EXACT_ALARM is not granted.
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
    bool isAlarm = false,
    bool repeatDaily = false,
    bool repeatWeekly = false,
  }) async {
    final soundType = LocalStorage.getReminderSoundType();
    String channelId = 'medicine_default';
    if (soundType == 'custom') channelId = 'medicine_custom';
    if (soundType == 'silent') channelId = 'medicine_silent';
    if (soundType == 'vibrate') channelId = 'medicine_vibrate';

    final isFullScreen = LocalStorage.isFullScreenAlarmEnabled() && isAlarm;

    final useExact = await _canUseExactAlarms();
    final scheduleMode = useExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexact;

    // Convert to TZDateTime using the device's local timezone
    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzScheduled,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            'Medicine Reminders',
            channelDescription: 'Notifications for medicine reminders',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            fullScreenIntent: isFullScreen,
            additionalFlags: isFullScreen ? Int32List.fromList([4]) : null,
            actions: const [
              AndroidNotificationAction('taken', '✅ Taken', showsUserInterface: false),
              AndroidNotificationAction('snooze', '⏰ Snooze', showsUserInterface: true),
              AndroidNotificationAction('skip', '❌ Skip', showsUserInterface: false),
            ],
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: scheduleMode,
        matchDateTimeComponents: repeatDaily
            ? DateTimeComponents.time
            : (repeatWeekly ? DateTimeComponents.dayOfWeekAndTime : null),
        payload: payload,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        // Retry once with inexact mode
        try {
          await _notificationsPlugin.zonedSchedule(
            id: id,
            title: title,
            body: body,
            scheduledDate: tzScheduled,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                channelId,
                'Medicine Reminders',
                importance: Importance.max,
                priority: Priority.high,
                actions: const [
                  AndroidNotificationAction('taken', '✅ Taken', showsUserInterface: false),
                  AndroidNotificationAction('snooze', '⏰ Snooze', showsUserInterface: true),
                  AndroidNotificationAction('skip', '❌ Skip', showsUserInterface: false),
                ],
              ),
              iOS: const DarwinNotificationDetails(),
            ),
            androidScheduleMode: AndroidScheduleMode.inexact,
            matchDateTimeComponents: repeatDaily
                ? DateTimeComponents.time
                : (repeatWeekly ? DateTimeComponents.dayOfWeekAndTime : null),
            payload: payload,
          );
        } catch (_) {}
      }
      // All other exceptions swallowed — notifications are best-effort
    } catch (_) {}
  }

  // ─── Water Notifications ───────────────────────────────────────────────────

  /// Cancels all water reminder notification slots (IDs 9000–9059).
  static Future<void> cancelWaterReminders() async {
    for (int i = 0; i < _maxWaterSlots; i++) {
      await _notificationsPlugin.cancel(id: 9000 + i);
    }
  }

  /// Reschedules water reminders for today from `now` until the end window.
  ///
  /// KEY FIX: Does NOT use `matchDateTimeComponents: DateTimeComponents.time`
  /// (which would make each notification repeat daily forever).
  /// Instead, each notification fires ONCE. This method is called fresh each day.
  static Future<void> rescheduleWaterReminders(double current, double target) async {
    await cancelWaterReminders();

    if (!LocalStorage.isWaterReminderEnabled()) return;

    final now = DateTime.now();
    final startHour = LocalStorage.getWaterStartHour();
    final startMin = LocalStorage.getWaterStartMinute();
    final endHour = LocalStorage.getWaterEndHour();
    final endMin = LocalStorage.getWaterEndMinute();
    final freqMin = LocalStorage.getWaterFrequencyMinutes();

    var startTime = DateTime(now.year, now.month, now.day, startHour, startMin);
    final endTime = DateTime(now.year, now.month, now.day, endHour, endMin);

    // Check exact alarm permission once
    final useExact = await _canUseExactAlarms();
    final scheduleMode = useExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexact;

    var currentSlot = startTime;
    int index = 0;

    while (currentSlot.isBefore(endTime) || currentSlot.isAtSameMomentAs(endTime)) {
      // Only schedule future slots
      if (currentSlot.isAfter(now) && index < _maxWaterSlots) {
        final id = 9000 + index;
        final progressText = '${current.round()} / ${target.round()} ml';

        try {
          await _notificationsPlugin.zonedSchedule(
            id: id,
            title: '💧 Stay Hydrated',
            body: 'Time to drink some water.\nToday\'s Progress: $progressText',
            scheduledDate: tz.TZDateTime.from(currentSlot, tz.local),
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'water_reminders',
                'Water Reminders',
                channelDescription: 'Notifications to remind you to drink water',
                importance: Importance.high,
                priority: Priority.high,
                actions: [
                  AndroidNotificationAction('water_add_150', '🥛 +150 ml', showsUserInterface: false),
                  AndroidNotificationAction('water_add_250', '🥤 +250 ml', showsUserInterface: false),
                  AndroidNotificationAction('water_add_500', '🍼 +500 ml', showsUserInterface: false),
                  AndroidNotificationAction('water_dismiss', 'Dismiss', showsUserInterface: false),
                ],
              ),
              iOS: DarwinNotificationDetails(),
            ),
            // NO matchDateTimeComponents — fires once, not daily forever
            androidScheduleMode: scheduleMode,
            payload: 'water_reminder',
          );
        } on PlatformException catch (e) {
          if (e.code == 'exact_alarms_not_permitted') {
            try {
              await _notificationsPlugin.zonedSchedule(
                id: id,
                title: '💧 Stay Hydrated',
                body: 'Time to drink some water.\nToday\'s Progress: $progressText',
                scheduledDate: tz.TZDateTime.from(currentSlot, tz.local),
                notificationDetails: const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'water_reminders',
                    'Water Reminders',
                    importance: Importance.high,
                    priority: Priority.high,
                  ),
                  iOS: DarwinNotificationDetails(),
                ),
                androidScheduleMode: AndroidScheduleMode.inexact,
                payload: 'water_reminder',
              );
            } catch (_) {}
          }
        } catch (_) {}
      }

      currentSlot = currentSlot.add(Duration(minutes: freqMin));
      index++;
    }
  }

  /// Called at app startup to schedule today's water reminders.
  static Future<void> scheduleDailyWaterReminders() async {
    final now = DateTime.now();
    final dateKey = '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}';
    final current = LocalStorage.getWaterIntake(dateKey);
    final target = LocalStorage.getWaterTarget();
    await rescheduleWaterReminders(current, target);
  }

  // ─── Utility ───────────────────────────────────────────────────────────────

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'stock_alerts',
          'Stock Alerts',
          channelDescription: 'Notifications for low medicine stocks',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
