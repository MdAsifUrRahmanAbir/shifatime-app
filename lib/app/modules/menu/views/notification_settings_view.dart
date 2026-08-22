import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_container.dart';
import '../widgets/settings_switch_row.dart';
import '../widgets/settings_dropdown_row.dart';
import '../widgets/settings_time_picker_row.dart';
import '../widgets/battery_compatibility_card.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  // Medicine Settings
  bool _fsAlarmEnabled = true;
  bool _repeatAlarmEnabled = false;
  int _repeatInterval = 5;
  int _maxRepeat = 3;
  String _soundType = 'default';

  // Water Settings
  bool _waterRemindersEnabled = true;
  int _waterFreq = 60;
  TimeOfDay _waterStart = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _waterEnd = const TimeOfDay(hour: 22, minute: 0);
  bool _waterSmartStop = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _fsAlarmEnabled = LocalStorage.isFullScreenAlarmEnabled();
      _repeatAlarmEnabled = LocalStorage.isRepeatAlarmEnabled();
      _repeatInterval = LocalStorage.getRepeatIntervalMinutes();
      _maxRepeat = LocalStorage.getMaxRepeatCount();
      _soundType = LocalStorage.getReminderSoundType();

      _waterRemindersEnabled = LocalStorage.isWaterReminderEnabled();
      _waterFreq = LocalStorage.getWaterFrequencyMinutes();
      _waterStart = TimeOfDay(
        hour: LocalStorage.getWaterStartHour(),
        minute: LocalStorage.getWaterStartMinute(),
      );
      _waterEnd = TimeOfDay(
        hour: LocalStorage.getWaterEndHour(),
        minute: LocalStorage.getWaterEndMinute(),
      );
      _waterSmartStop = LocalStorage.isWaterSmartStopEnabled();
    });
  }

  void _onWaterSettingsChanged() {
    LocalStorage.saveWaterReminderEnabled(_waterRemindersEnabled);
    LocalStorage.saveWaterFrequencyMinutes(_waterFreq);
    LocalStorage.saveWaterStartHour(_waterStart.hour);
    LocalStorage.saveWaterStartMinute(_waterStart.minute);
    LocalStorage.saveWaterEndHour(_waterEnd.hour);
    LocalStorage.saveWaterEndMinute(_waterEnd.minute);
    LocalStorage.saveWaterSmartStopEnabled(_waterSmartStop);

    if (_waterRemindersEnabled) {
      NotificationService.scheduleDailyWaterReminders();
    } else {
      NotificationService.cancelWaterReminders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ResponsiveLayout(
        mobile: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ────────────────── MEDICINE ALARM SETTINGS ──────────────────
              const SettingsSectionHeader(label: 'MEDICINE ALARMS & SOUNDS', icon: Icons.alarm_rounded),
              const SizedBox(height: 16),
              SettingsContainer(
                isDark: isDark,
                children: [
                  // Full Screen Alarm
                  SettingsSwitchRow(
                    title: 'Full-Screen Alarm',
                    desc: 'Show full-screen alarm overlay when device rings',
                    value: _fsAlarmEnabled,
                    onChanged: (val) {
                      setState(() => _fsAlarmEnabled = val);
                      LocalStorage.saveFullScreenAlarmEnabled(val);
                    },
                  ),
                  const Divider(height: 32),

                  // Sound style select
                  SettingsDropdownRow<String>(
                    title: 'Reminder Sound',
                    desc: 'Sound profile for active alerts',
                    value: _soundType,
                    items: const [
                      DropdownMenuItem(value: 'default', child: Text('Default System')),
                      DropdownMenuItem(value: 'custom', child: Text('Custom Sound')),
                      DropdownMenuItem(value: 'silent', child: Text('Silent (None)')),
                      DropdownMenuItem(value: 'vibrate', child: Text('Vibration Only')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _soundType = val);
                        LocalStorage.saveReminderSoundType(val);
                      }
                    },
                  ),
                  const Divider(height: 32),

                  // Repeat Alarm
                  SettingsSwitchRow(
                    title: 'Repeat Alarm Until Acknowledged',
                    desc: 'Keep alerting if ignored',
                    value: _repeatAlarmEnabled,
                    onChanged: (val) {
                      setState(() => _repeatAlarmEnabled = val);
                      LocalStorage.saveRepeatAlarmEnabled(val);
                    },
                  ),
                  if (_repeatAlarmEnabled) ...[
                    const Divider(height: 32),
                    SettingsDropdownRow<int>(
                      title: 'Repeat Interval',
                      desc: 'Delay between repeat reminders',
                      value: _repeatInterval,
                      items: const [
                        DropdownMenuItem(value: 2, child: Text('Every 2 Minutes')),
                        DropdownMenuItem(value: 5, child: Text('Every 5 Minutes')),
                        DropdownMenuItem(value: 10, child: Text('Every 10 Minutes')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _repeatInterval = val);
                          LocalStorage.saveRepeatIntervalMinutes(val);
                        }
                      },
                    ),
                    const Divider(height: 32),
                    SettingsDropdownRow<int>(
                      title: 'Maximum Repeat Count',
                      desc: 'Number of times to retry ringing',
                      value: _maxRepeat,
                      items: const [
                        DropdownMenuItem(value: 3, child: Text('3 Times')),
                        DropdownMenuItem(value: 5, child: Text('5 Times')),
                        DropdownMenuItem(value: 10, child: Text('10 Times')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _maxRepeat = val);
                          LocalStorage.saveMaxRepeatCount(val);
                        }
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),

              // ────────────────── WATER REMINDER SETTINGS ──────────────────
              const SettingsSectionHeader(label: 'WATER REMINDER SETTINGS', icon: Icons.local_drink_rounded),
              const SizedBox(height: 16),
              SettingsContainer(
                isDark: isDark,
                children: [
                  // Enable reminders
                  SettingsSwitchRow(
                    title: 'Hydration Reminders',
                    desc: 'Get local notifications to drink water',
                    value: _waterRemindersEnabled,
                    onChanged: (val) {
                      setState(() => _waterRemindersEnabled = val);
                      _onWaterSettingsChanged();
                    },
                  ),
                  if (_waterRemindersEnabled) ...[
                    const Divider(height: 32),

                    // Frequency
                    SettingsDropdownRow<int>(
                      title: 'Reminder Frequency',
                      desc: 'Time gap between reminders',
                      value: _waterFreq,
                      items: const [
                        DropdownMenuItem(value: 30, child: Text('Every 30 Minutes')),
                        DropdownMenuItem(value: 45, child: Text('Every 45 Minutes')),
                        DropdownMenuItem(value: 60, child: Text('Every 1 Hour')),
                        DropdownMenuItem(value: 120, child: Text('Every 2 Hours')),
                        DropdownMenuItem(value: 180, child: Text('Every 3 Hours')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _waterFreq = val);
                          _onWaterSettingsChanged();
                        }
                      },
                    ),
                    const Divider(height: 32),

                    // Start Time Picker
                    SettingsTimePickerRow(
                      title: 'Active Start Hour',
                      desc: 'Reminders begin from this time',
                      time: _waterStart,
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: _waterStart);
                        if (time != null) {
                          setState(() => _waterStart = time);
                          _onWaterSettingsChanged();
                        }
                      },
                    ),
                    const Divider(height: 32),

                    // End Time Picker
                    SettingsTimePickerRow(
                      title: 'Active End Hour',
                      desc: 'Stop scheduling reminders after this time',
                      time: _waterEnd,
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: _waterEnd);
                        if (time != null) {
                          setState(() => _waterEnd = time);
                          _onWaterSettingsChanged();
                        }
                      },
                    ),
                    const Divider(height: 32),

                    // Smart Stop
                    SettingsSwitchRow(
                      title: 'Smart Stop',
                      desc: 'Automatically stop reminders when daily target is met',
                      value: _waterSmartStop,
                      onChanged: (val) {
                        setState(() => _waterSmartStop = val);
                        _onWaterSettingsChanged();
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),

              // ────────────────── BATTERY OPTIMIZATION GUIDE ──────────────────
              const SettingsSectionHeader(label: 'BATTERY & DEVICE COMPATIBILITY', icon: Icons.battery_charging_full_rounded),
              const SizedBox(height: 16),
              BatteryCompatibilityCard(isDark: isDark),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
