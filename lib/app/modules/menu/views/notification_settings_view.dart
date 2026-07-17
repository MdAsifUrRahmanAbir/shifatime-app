import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/notification_service.dart';

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ────────────────── MEDICINE ALARM SETTINGS ──────────────────
            _buildSectionHeader('MEDICINE ALARMS & SOUNDS', Icons.alarm_rounded),
            const SizedBox(height: 16),
            _buildSettingsContainer(
              isDark,
              [
                // Full Screen Alarm
                _buildSwitchRow(
                  'Full-Screen Alarm',
                  'Show full-screen alarm overlay when device rings',
                  _fsAlarmEnabled,
                  (val) {
                    setState(() => _fsAlarmEnabled = val);
                    LocalStorage.saveFullScreenAlarmEnabled(val);
                  },
                ),
                const Divider(height: 32),

                // Sound style select
                _buildDropdownRow<String>(
                  'Reminder Sound',
                  'Sound profile for active alerts',
                  _soundType,
                  [
                    const DropdownMenuItem(value: 'default', child: Text('Default System')),
                    const DropdownMenuItem(value: 'custom', child: Text('Custom Sound')),
                    const DropdownMenuItem(value: 'silent', child: Text('Silent (None)')),
                    const DropdownMenuItem(value: 'vibrate', child: Text('Vibration Only')),
                  ],
                  (val) {
                    if (val != null) {
                      setState(() => _soundType = val);
                      LocalStorage.saveReminderSoundType(val);
                    }
                  },
                ),
                const Divider(height: 32),

                // Repeat Alarm
                _buildSwitchRow(
                  'Repeat Alarm Until Acknowledged',
                  'Keep alerting if ignored',
                  _repeatAlarmEnabled,
                  (val) {
                    setState(() => _repeatAlarmEnabled = val);
                    LocalStorage.saveRepeatAlarmEnabled(val);
                  },
                ),
                if (_repeatAlarmEnabled) ...[
                  const Divider(height: 32),
                  _buildDropdownRow<int>(
                    'Repeat Interval',
                    'Delay between repeat reminders',
                    _repeatInterval,
                    [
                      const DropdownMenuItem(value: 2, child: Text('Every 2 Minutes')),
                      const DropdownMenuItem(value: 5, child: Text('Every 5 Minutes')),
                      const DropdownMenuItem(value: 10, child: Text('Every 10 Minutes')),
                    ],
                    (val) {
                      if (val != null) {
                        setState(() => _repeatInterval = val);
                        LocalStorage.saveRepeatIntervalMinutes(val);
                      }
                    },
                  ),
                  const Divider(height: 32),
                  _buildDropdownRow<int>(
                    'Maximum Repeat Count',
                    'Number of times to retry ringing',
                    _maxRepeat,
                    [
                      const DropdownMenuItem(value: 3, child: Text('3 Times')),
                      const DropdownMenuItem(value: 5, child: Text('5 Times')),
                      const DropdownMenuItem(value: 10, child: Text('10 Times')),
                    ],
                    (val) {
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
            _buildSectionHeader('WATER REMINDER SETTINGS', Icons.local_drink_rounded),
            const SizedBox(height: 16),
            _buildSettingsContainer(
              isDark,
              [
                // Enable reminders
                _buildSwitchRow(
                  'Hydration Reminders',
                  'Get local notifications to drink water',
                  _waterRemindersEnabled,
                  (val) {
                    setState(() => _waterRemindersEnabled = val);
                    _onWaterSettingsChanged();
                  },
                ),
                if (_waterRemindersEnabled) ...[
                  const Divider(height: 32),

                  // Frequency
                  _buildDropdownRow<int>(
                    'Reminder Frequency',
                    'Time gap between reminders',
                    _waterFreq,
                    [
                      const DropdownMenuItem(value: 30, child: Text('Every 30 Minutes')),
                      const DropdownMenuItem(value: 45, child: Text('Every 45 Minutes')),
                      const DropdownMenuItem(value: 60, child: Text('Every 1 Hour')),
                      const DropdownMenuItem(value: 120, child: Text('Every 2 Hours')),
                      const DropdownMenuItem(value: 180, child: Text('Every 3 Hours')),
                    ],
                    (val) {
                      if (val != null) {
                        setState(() => _waterFreq = val);
                        _onWaterSettingsChanged();
                      }
                    },
                  ),
                  const Divider(height: 32),

                  // Start Time Picker
                  _buildTimePickerRow(
                    'Active Start Hour',
                    'Reminders begin from this time',
                    _waterStart,
                    () async {
                      final time = await showTimePicker(context: context, initialTime: _waterStart);
                      if (time != null) {
                        setState(() => _waterStart = time);
                        _onWaterSettingsChanged();
                      }
                    },
                  ),
                  const Divider(height: 32),

                  // End Time Picker
                  _buildTimePickerRow(
                    'Active End Hour',
                    'Stop scheduling reminders after this time',
                    _waterEnd,
                    () async {
                      final time = await showTimePicker(context: context, initialTime: _waterEnd);
                      if (time != null) {
                        setState(() => _waterEnd = time);
                        _onWaterSettingsChanged();
                      }
                    },
                  ),
                  const Divider(height: 32),

                  // Smart Stop
                  _buildSwitchRow(
                    'Smart Stop',
                    'Automatically stop reminders when daily target is met',
                    _waterSmartStop,
                    (val) {
                      setState(() => _waterSmartStop = val);
                      _onWaterSettingsChanged();
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 32),

            // ────────────────── BATTERY OPTIMIZATION GUIDE ──────────────────
            _buildSectionHeader('BATTERY & DEVICE COMPATIBILITY', Icons.battery_charging_full_rounded),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Important for Android Users',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Aggressive battery savers on devices (Samsung, Xiaomi, Oppo, OnePlus, Vivo) may block reminders when the app is closed.',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '💡 Recommendation:',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Please disable Battery Optimization for ShifaTime in your system settings to ensure alarms trigger reliably at the exact minute.',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsContainer(bool isDark, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchRow(String title, String desc, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.limeAccent,
        ),
      ],
    );
  }

  Widget _buildDropdownRow<T>(
    String title,
    String desc,
    T value,
    List<DropdownMenuItem<T>> items,
    ValueChanged<T?> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerRow(String title, String desc, TimeOfDay time, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            foregroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            time.format(context),
            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
