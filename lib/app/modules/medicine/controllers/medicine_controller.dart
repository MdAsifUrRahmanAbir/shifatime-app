import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/medicine_model.dart';
import '../../../data/models/dose_record_model.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/local_storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MedicineController extends GetxController {
  final Box<Medicine> medicineBox = Hive.box<Medicine>('medicines');
  final Box<DoseRecord> doseBox = Hive.box<DoseRecord>('dose_records');

  var medicines = <Medicine>[].obs;
  var todayDoses = <DoseRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
    // ── FIX: Run full notification bootstrap on every launch ──────────────────
    // This ensures alarms survive app kills, reboots, and OS eviction.
    _bootstrapNotifications();
  }

  /// Generates today's dose records, marks missed doses, then reschedules ALL
  /// pending medicine notifications and water reminders. Called on every launch.
  Future<void> _bootstrapNotifications() async {
    await generateTodayDoseRecords();
    await _scheduleAllPendingNotifications();       // Fix 3: reschedule medicines
    await NotificationService.scheduleDailyWaterReminders(); // Fix 4: water reminders
    NotificationService.requestPermissionsWithConfirmation(); // permission dialog
  }

  final Map<String, String> timeSlots = {
    'Sokal': '08:00',
    'Dupur': '14:00',
    'Bikal': '17:00',
    'Rat': '22:00',
  };

  void loadMedicines() {
    medicines.assignAll(medicineBox.values.toList());
  }

  Future<void> addMedicine(Medicine medicine) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    medicine.id = id;
    medicine.startDate = DateTime.now();
    await medicineBox.put(id, medicine);
    medicines.add(medicine);

    // Generate and schedule
    generateTodayDoseRecords();
    _scheduleNotifications(medicine);
  }

  Future<void> deleteMedicine(String id) async {
    await medicineBox.delete(id);
    medicines.removeWhere((m) => m.id == id);

    // Remove matching dose records and cancel notifications
    final matchingDoses = doseBox.values.where((d) => d.medicineId == id).toList();
    for (final dose in matchingDoses) {
      await NotificationService.cancelNotification(dose.id.hashCode);
      await NotificationService.cancelNotification(dose.id.hashCode + 888);
      await dose.delete();
    }
    generateTodayDoseRecords();
  }

  /// Schedules notifications for a single medicine (called on addMedicine / toggleActive).
  Future<void> _scheduleNotifications(Medicine medicine) async {
    if (!(medicine.isActive ?? false) || medicine.reminderTimes == null) return;

    final now = DateTime.now();

    // Ensure dose records exist for today and tomorrow
    _generateDoseRecordsForDate(medicine, now);
    _generateDoseRecordsForDate(medicine, now.add(const Duration(days: 1)));

    final upcomingDoses = doseBox.values.where((d) =>
        d.medicineId == medicine.id &&
        (d.status == 'pending' || d.status == 'snoozed'));

    for (final dose in upcomingDoses) {
      final scheduledDate = _parseDoseDateTime(dose);
      if (scheduledDate != null && scheduledDate.isAfter(now)) {
        await NotificationService.scheduleNotification(
          id: dose.id.hashCode,
          title: _getNotificationTitle(medicine),
          body: _getNotificationBody(medicine),
          scheduledDate: scheduledDate,
          payload: 'med_${dose.id}',
          isAlarm: true,
        );
      }
    }
  }

  /// ── FIX 3: Reschedules ALL pending medicine alarms on every launch ──────────
  /// This ensures that after app kill / reboot, every dose alarm is restored.
  Future<void> _scheduleAllPendingNotifications() async {
    final now = DateTime.now();

    for (final medicine in medicineBox.values) {
      if (!(medicine.isActive ?? false) || medicine.reminderTimes == null) continue;

      // Ensure records for today and tomorrow
      _generateDoseRecordsForDate(medicine, now);
      _generateDoseRecordsForDate(medicine, now.add(const Duration(days: 1)));
    }

    // Collect all future pending/snoozed doses
    final todayStr = _dateKey(now);
    final tomorrowStr = _dateKey(now.add(const Duration(days: 1)));

    final activeDoses = doseBox.values.where((d) =>
        (d.dateStr == todayStr || d.dateStr == tomorrowStr) &&
        (d.status == 'pending' || d.status == 'snoozed')).toList();

    for (final dose in activeDoses) {
      final scheduledDate = _parseDoseDateTime(dose);
      if (scheduledDate == null || !scheduledDate.isAfter(now)) continue;

      final medicine = medicineBox.get(dose.medicineId);
      if (medicine == null) continue;

      await NotificationService.scheduleNotification(
        id: dose.id.hashCode,
        title: _getNotificationTitle(medicine),
        body: _getNotificationBody(medicine),
        scheduledDate: scheduledDate,
        payload: 'med_${dose.id}',
        isAlarm: true,
      );
    }
  }

  /// Parse a DoseRecord's date+time strings into a DateTime. Returns null on error.
  DateTime? _parseDoseDateTime(DoseRecord dose) {
    try {
      final timeParts = dose.timeStr!.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final dateParts = dose.dateStr!.split('_');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);
      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  String _dateKey(DateTime d) =>
      '${d.year}_${d.month.toString().padLeft(2, '0')}_${d.day.toString().padLeft(2, '0')}';



  void _generateDoseRecordsForDate(Medicine medicine, DateTime date) {
    if (!_isMedicineScheduledForDate(medicine, date)) return;

    final dateStr = '${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}';

    for (int i = 0; i < medicine.reminderTimes!.length; i++) {
      String timeStr = medicine.reminderTimes![i];
      if (timeSlots.containsKey(timeStr)) {
        timeStr = timeSlots[timeStr]!;
      }

      final doseId = '${medicine.id}_${dateStr}_$i';
      if (!doseBox.containsKey(doseId)) {
        final dosageStr = medicine.customDosage ?? '${medicine.dosage} ${medicine.type}';
        final record = DoseRecord(
          id: doseId,
          medicineId: medicine.id,
          medicineName: medicine.name,
          timeStr: timeStr,
          dateStr: dateStr,
          status: 'pending',
          customDosage: dosageStr,
          medicineType: medicine.type,
          mealRelation: medicine.mealRelation,
        );
        doseBox.put(doseId, record);
      }
    }
  }

  Future<void> generateTodayDoseRecords() async {
    final now = DateTime.now();
    final todayStr = '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}';

    // Generate records for today
    for (final medicine in medicineBox.values) {
      if (medicine.isActive!) {
        _generateDoseRecordsForDate(medicine, now);
      }
    }

    // Load active records
    final list = doseBox.values.where((d) => d.dateStr == todayStr).toList();

    // Check for missed doses (if time passed and status is pending)
    for (final dose in list) {
      if (dose.status == 'pending') {
        final parts = dose.timeStr!.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

        // If scheduled time is more than 1 hour in the past, mark as missed
        if (now.difference(scheduledTime).inHours >= 1) {
          dose.status = 'missed';
          await dose.save();

          final logBox = Hive.box('activity_logs');
          await logBox.add({
            'id': 'med_${dose.id}_missed',
            'type': 'medicine',
            'name': dose.medicineName ?? 'Medicine',
            'action': 'missed',
            'timestamp': now.toIso8601String(),
            'details': '${dose.customDosage} • ${dose.mealRelation}',
          });
        }
      }
    }

    // Sort chronologically
    list.sort((a, b) => (a.timeStr ?? '').compareTo(b.timeStr ?? ''));
    todayDoses.assignAll(list);
  }

  Future<void> verifyAndHealReminders() async {
    final now = DateTime.now();
    final localNotifications = FlutterLocalNotificationsPlugin();

    // 1. Get all scheduled notifications from system
    final pendingRequests = await localNotifications.pendingNotificationRequests();
    final pendingIds = pendingRequests.map((r) => r.id).toSet();

    // 2. Generate expected reminders for today and tomorrow
    for (final medicine in medicineBox.values) {
      if (medicine.isActive!) {
        _generateDoseRecordsForDate(medicine, now);
        _generateDoseRecordsForDate(medicine, now.add(const Duration(days: 1)));
      }
    }

    // 3. Compare and heal missing notifications
    final todayStr = '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}';
    final tomorrowStr = '${now.add(const Duration(days: 1)).year}_${now.add(const Duration(days: 1)).month.toString().padLeft(2, '0')}_${now.add(const Duration(days: 1)).day.toString().padLeft(2, '0')}';

    final activeDoses = doseBox.values.where((d) =>
        (d.dateStr == todayStr || d.dateStr == tomorrowStr) &&
        (d.status == 'pending' || d.status == 'snoozed')).toList();

    for (final dose in activeDoses) {
      final parts = dose.timeStr!.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final dateParts = dose.dateStr!.split('_');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      final scheduledDate = DateTime(year, month, day, hour, minute);

      if (scheduledDate.isAfter(now)) {
        final notificationId = dose.id.hashCode;
        if (!pendingIds.contains(notificationId)) {
          final medicine = medicineBox.get(dose.medicineId);
          if (medicine != null) {
            await NotificationService.scheduleNotification(
              id: notificationId,
              title: _getNotificationTitle(medicine),
              body: _getNotificationBody(medicine),
              scheduledDate: scheduledDate,
              payload: 'med_${dose.id}',
              isAlarm: true,
            );
          }
        }
      }
    }
  }

  bool _isMedicineScheduledForDate(Medicine medicine, DateTime date) {
    if (!medicine.isActive!) return false;
    final startDate = medicine.startDate ?? date;

    // Check duration limit
    if (medicine.durationType == 'Specified') {
      final val = int.tryParse(medicine.durationValue ?? '') ?? 0;
      if (val <= 0) return true;
      DateTime expiryDate;
      if (medicine.durationUnit == 'Weeks') {
        expiryDate = startDate.add(Duration(days: val * 7));
      } else if (medicine.durationUnit == 'Months') {
        expiryDate = DateTime(startDate.year, startDate.month + val, startDate.day);
      } else {
        expiryDate = startDate.add(Duration(days: val));
      }
      final expiryDayEnd = DateTime(expiryDate.year, expiryDate.month, expiryDate.day, 23, 59, 59);
      if (date.isAfter(expiryDayEnd)) return false;
    }

    // Check specific days
    if (medicine.durationType == 'Specific Days') {
      final dayName = _getDayName(date.weekday);
      final activeDays = medicine.durationValue?.split(',') ?? [];
      if (!activeDays.contains(dayName)) return false;
    }

    return true;
  }

  Future<void> toggleMedicineStatus(Medicine medicine) async {
    medicine.isActive = !medicine.isActive!;
    await medicine.save();

    if (medicine.isActive!) {
      generateTodayDoseRecords();
      _scheduleNotifications(medicine);
    } else {
      final matchingDoses = doseBox.values.where((d) => d.medicineId == medicine.id && d.status == 'pending').toList();
      for (final dose in matchingDoses) {
        await NotificationService.cancelNotification(dose.id.hashCode);
        await dose.delete();
      }
      generateTodayDoseRecords();
    }
    medicines.refresh();
  }

  Future<void> takeDose(DoseRecord dose) async {
    dose.status = 'taken';
    dose.takenTime = DateTime.now();
    await dose.save();

    // 1. Decrease Stock if specified
    final medicine = medicineBox.get(dose.medicineId);
    if (medicine != null && medicine.totalStock != null) {
      final dosage = medicine.dosage ?? 1;
      medicine.totalStock = (medicine.totalStock! - dosage).clamp(0, 99999);
      await medicine.save();
      loadMedicines(); // Refresh medicine list

      // Show alert if stock drops below threshold
      if (medicine.totalStock! <= (medicine.stockThreshold ?? 5)) {
        await NotificationService.showImmediateNotification(
          id: medicine.id.hashCode + 999,
          title: '⚠️ Medicine Running Low',
          body: '${medicine.name} is running low! Only ${medicine.totalStock} left.',
        );
      }
    }

    // 2. Add history log
    final now = DateTime.now();
    final logBox = Hive.box('activity_logs');
    final dosageStr = dose.customDosage ?? '1 Dose';
    await logBox.add({
      'id': 'med_${dose.id}_${now.toIso8601String()}',
      'type': 'medicine',
      'name': dose.medicineName ?? 'Medicine',
      'action': 'taken',
      'timestamp': now.toIso8601String(),
      'details': '$dosageStr • ${dose.mealRelation}',
    });

    // 3. Update Streak & Adherence Metrics
    final today = _getTodayKey();
    final lastActive = LocalStorage.getLastActiveDate();

    final currentCount = LocalStorage.getMedicinesTakenCount();
    LocalStorage.saveMedicinesTakenCount(currentCount + 1);

    if (lastActive != today) {
      if (lastActive.isNotEmpty) {
        final lastDate = DateTime.tryParse(lastActive.replaceAll('_', '-'));
        final todayDate = DateTime.now();
        if (lastDate != null && todayDate.difference(lastDate).inDays == 1) {
          LocalStorage.saveMedicineStreak(LocalStorage.getMedicineStreak() + 1);
        } else if (lastDate != null && todayDate.difference(lastDate).inDays > 1) {
          LocalStorage.saveMedicineStreak(1);
        }
      } else {
        LocalStorage.saveMedicineStreak(1);
      }
      LocalStorage.saveLastActiveDate(today);
    }

    generateTodayDoseRecords();
  }

  Future<void> skipDose(DoseRecord dose) async {
    dose.status = 'skipped';
    await dose.save();

    final now = DateTime.now();
    final logBox = Hive.box('activity_logs');
    final dosageStr = dose.customDosage ?? '1 Dose';
    await logBox.add({
      'id': 'med_${dose.id}_${now.toIso8601String()}',
      'type': 'medicine',
      'name': dose.medicineName ?? 'Medicine',
      'action': 'skipped',
      'timestamp': now.toIso8601String(),
      'details': '$dosageStr • ${dose.mealRelation}',
    });

    generateTodayDoseRecords();
  }

  Future<void> snoozeDose(DoseRecord dose, int minutes) async {
    final now = DateTime.now();
    final snoozeTime = now.add(Duration(minutes: minutes));
    dose.status = 'snoozed';
    dose.snoozeUntil = snoozeTime;
    await dose.save();

    final logBox = Hive.box('activity_logs');
    await logBox.add({
      'id': 'med_${dose.id}_snooze_${now.toIso8601String()}',
      'type': 'medicine',
      'name': dose.medicineName ?? 'Medicine',
      'action': 'snoozed',
      'timestamp': now.toIso8601String(),
      'details': 'Snoozed for $minutes Minutes',
    });

    // Schedule a one-shot notification at snoozeTime
    await NotificationService.scheduleNotification(
      id: dose.id.hashCode + 888,
      title: '⏰ Snoozed: ${dose.medicineName}',
      body: 'Take ${dose.customDosage}',
      scheduledDate: snoozeTime,
      payload: 'med_${dose.id}',
      isAlarm: true,
    );

    generateTodayDoseRecords();
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Mon';
      case DateTime.tuesday: return 'Tue';
      case DateTime.wednesday: return 'Wed';
      case DateTime.thursday: return 'Thu';
      case DateTime.friday: return 'Fri';
      case DateTime.saturday: return 'Sat';
      case DateTime.sunday: return 'Sun';
      default: return '';
    }
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}';
  }

  String _getNotificationTitle(Medicine medicine) {
    final type = medicine.type?.toLowerCase() ?? '';
    final name = medicine.name ?? 'Medicine';

    switch (type) {
      case 'tablet':
        return '💊 Time to take $name';
      case 'capsule':
        return '🟢 Time to take $name';
      case 'syrup':
        return '🧴 Time to take $name';
      case 'injection':
        return '💉 Time for $name Injection';
      case 'cream':
        return '🩹 Time to apply $name';
      case 'eye drop':
        return '💧 Time to apply $name';
      case 'ear drop':
        return '👂 Time to apply $name';
      case 'nasal spray':
        return '👃 Time to apply $name';
      case 'inhaler':
        return '🌫 Time to use $name';
      case 'patch':
        return '🩹 Time to apply $name Patch';
      default:
        return '💊 Time to take $name';
    }
  }

  String _getNotificationBody(Medicine medicine) {
    final dosageStr = medicine.customDosage ?? '${medicine.dosage} ${medicine.type}';
    final areaStr = (medicine.applicationArea != null && medicine.applicationArea!.isNotEmpty)
        ? ' on ${medicine.applicationArea}'
        : '';
    final instructStr = (medicine.usageInstruction != null && medicine.usageInstruction!.isNotEmpty)
        ? ' (${medicine.usageInstruction})'
        : '';
    return 'Dosage: $dosageStr$areaStr • ${medicine.mealRelation}$instructStr';
  }
}
