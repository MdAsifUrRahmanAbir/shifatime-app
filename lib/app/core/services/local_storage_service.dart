import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ── Key constants ────────────────────────────────────────────────────────────
const String _tokenKey = 'tokenKey';
const String _nameKey = 'nameKey';
const String _emailKey = 'emailKey';
const String _imageKey = 'imageKey';
const String _isLoggedInKey = 'isLoggedInKey';
const String _isOnBoardKey = 'isOnBoardDoneKey';
const String _isDarkModeKey = 'isDarkModeKey';
const String _languageKey = 'languageKey';
const String _langSmallKey = 'langSmallKey';
const String _langCapKey = 'langCapKey';

// Profile & Water Intake Keys
const String _ageKey = 'userAge';
const String _heightKey = 'userHeight';
const String _weightKey = 'userWeight';
const String _waterTargetKey = 'userWaterTarget';
const String _waterIntakeHistoryPrefix = 'waterIntakeHistory_';

/// Static local storage utility backed by GetStorage.
///
/// Initialise once in `main()` before `runApp`:
///   await GetStorage.init();
///
/// Then use anywhere:
///   LocalStorage.saveToken(token: 'abc');
///   String? token = LocalStorage.getToken();
///   LocalStorage.signOut();
class LocalStorage {
  LocalStorage._();

  static GetStorage get _box => GetStorage();

  // ── Token ────────────────────────────────────────────────────────────────
  static Future<void> saveToken({required String token}) =>
      _box.write(_tokenKey, token);

  static String? getToken() {
    final t = _box.read<String>(_tokenKey);
    debugPrint(t == null ? '## Token is null ##' : '## Token found ##');
    return t;
  }

  static bool hasToken() => getToken() != null;

  // ── User ─────────────────────────────────────────────────────────────────
  static Future<void> saveName({required String name}) =>
      _box.write(_nameKey, name);
  static String getName() => _box.read(_nameKey) ?? '';

  static Future<void> saveEmail({required String email}) =>
      _box.write(_emailKey, email);
  static String getEmail() => _box.read(_emailKey) ?? '';

  static Future<void> saveImage({required String url}) =>
      _box.write(_imageKey, url);
  static String? getImage() => _box.read<String>(_imageKey);

  // ── Auth State ────────────────────────────────────────────────────────────
  static Future<void> setLoggedIn({required bool value}) =>
      _box.write(_isLoggedInKey, value);
  static bool isLoggedIn() => _box.read(_isLoggedInKey) ?? false;

  // ── Onboard ───────────────────────────────────────────────────────────────
  static Future<void> setOnboardDone({required bool value}) =>
      _box.write(_isOnBoardKey, value);
  static bool isOnboardDone() => _box.read(_isOnBoardKey) ?? false;

  // ── Theme ─────────────────────────────────────────────────────────────────
  static Future<void> saveDarkMode({required bool isDark}) =>
      _box.write(_isDarkModeKey, isDark);
  static bool isDarkMode() => _box.read(_isDarkModeKey) ?? false;

  static void switchTheme() {
    final current = isDarkMode();
    _box.write(_isDarkModeKey, !current);
    Get.changeThemeMode(current ? ThemeMode.light : ThemeMode.dark);
  }

  // ── Language ──────────────────────────────────────────────────────────────
  static Future<void> saveLanguage({
    required String name, // e.g. 'English'
    required String langSmall, // e.g. 'en'
    required String langCap, // e.g. 'EN'
  }) async {
    await _box.write(_languageKey, name);
    await _box.write(_langSmallKey, langSmall);
    await _box.write(_langCapKey, langCap);
    final locale = Locale(langSmall, langCap);
    Get.updateLocale(locale);
  }

  static List<String> getLanguage() => [
    _box.read(_langSmallKey) ?? 'en',
    _box.read(_langCapKey) ?? 'EN',
    _box.read(_languageKey) ?? 'English',
  ];

  // ── Profile ───────────────────────────────────────────────────────────────
  static bool hasProfile() => getName().isNotEmpty && getWeight() > 0 && getHeight() > 0;

  static Future<void> saveProfile({
    required String name,
    required int age,
    required double height,
    required double weight,
    required double waterTarget,
    required String gender,
  }) async {
    await _box.write(_nameKey, name);
    await _box.write(_ageKey, age);
    await _box.write(_heightKey, height);
    await _box.write(_weightKey, weight);
    await _box.write(_waterTargetKey, waterTarget);
    await _box.write('userGender', gender);
  }

  static int getAge() => _box.read(_ageKey) ?? 0;
  static double getHeight() => _box.read(_heightKey) ?? 0.0;
  static double getWeight() => _box.read(_weightKey) ?? 0.0;
  static double getWaterTarget() => _box.read(_waterTargetKey) ?? 2000.0;
  static String getGender() => _box.read('userGender') ?? 'Male';
  static Future<void> saveGender(String gender) => _box.write('userGender', gender);

  // ── Water Intake ──────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> getWaterLogs(String date) {
    final list = _box.read<List<dynamic>>('$_waterIntakeHistoryPrefix$date') ?? [];
    return list.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  static Future<void> saveWaterLogs(String date, List<Map<String, dynamic>> logs) async {
    await _box.write('$_waterIntakeHistoryPrefix$date', logs);
  }

  static double getWaterIntake(String date) {
    final logs = getWaterLogs(date);
    double total = 0.0;
    for (final log in logs) {
      total += (log['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  // ── Streaks & Achievements ────────────────────────────────────────────────
  static int getWaterStreak() => _box.read('waterStreak') ?? 0;
  static Future<void> saveWaterStreak(int val) => _box.write('waterStreak', val);

  static int getMedicineStreak() => _box.read('medicineStreak') ?? 0;
  static Future<void> saveMedicineStreak(int val) => _box.write('medicineStreak', val);

  static int getMedicinesTakenCount() => _box.read('medicinesTakenCount') ?? 0;
  static Future<void> saveMedicinesTakenCount(int val) => _box.write('medicinesTakenCount', val);

  static int getWaterGlassesCount() => _box.read('waterGlassesCount') ?? 0;
  static Future<void> saveWaterGlassesCount(int val) => _box.write('waterGlassesCount', val);

  static String getLastActiveDate() => _box.read('lastActiveDate') ?? '';
  static Future<void> saveLastActiveDate(String date) => _box.write('lastActiveDate', date);

  // ── Sign Out ──────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _box.remove(_tokenKey);
    await _box.remove(_nameKey);
    await _box.remove(_emailKey);
    await _box.remove(_imageKey);
    await _box.remove(_isLoggedInKey);
    await _box.remove(_ageKey);
    await _box.remove(_heightKey);
    await _box.remove(_weightKey);
    await _box.remove(_waterTargetKey);
    // Keep onboard status — user has already seen it
  }

  // ── Notification & Alarm Settings ─────────────────────────────────────────
  static bool isFullScreenAlarmEnabled() => _box.read('fsAlarmEnabled') ?? true;
  static Future<void> saveFullScreenAlarmEnabled(bool val) => _box.write('fsAlarmEnabled', val);

  static bool isRepeatAlarmEnabled() => _box.read('repeatAlarmEnabled') ?? false;
  static Future<void> saveRepeatAlarmEnabled(bool val) => _box.write('repeatAlarmEnabled', val);

  static int getRepeatIntervalMinutes() => _box.read('repeatIntervalMin') ?? 5;
  static Future<void> saveRepeatIntervalMinutes(int val) => _box.write('repeatIntervalMin', val);

  static int getMaxRepeatCount() => _box.read('maxRepeatCount') ?? 3;
  static Future<void> saveMaxRepeatCount(int val) => _box.write('maxRepeatCount', val);

  static String getReminderSoundType() => _box.read('reminderSoundType') ?? 'default'; // default, custom, silent, vibrate
  static Future<void> saveReminderSoundType(String val) => _box.write('reminderSoundType', val);

  static bool isWaterReminderEnabled() => _box.read('waterReminderEnabled') ?? true;
  static Future<void> saveWaterReminderEnabled(bool val) => _box.write('waterReminderEnabled', val);

  static int getWaterFrequencyMinutes() => _box.read('waterFreqMin') ?? 60;
  static Future<void> saveWaterFrequencyMinutes(int val) => _box.write('waterFreqMin', val);

  static int getWaterStartHour() => _box.read('waterStartHour') ?? 8;
  static Future<void> saveWaterStartHour(int val) => _box.write('waterStartHour', val);

  static int getWaterStartMinute() => _box.read('waterStartMin') ?? 0;
  static Future<void> saveWaterStartMinute(int val) => _box.write('waterStartMin', val);

  static int getWaterEndHour() => _box.read('waterEndHour') ?? 22;
  static Future<void> saveWaterEndHour(int val) => _box.write('waterEndHour', val);

  static int getWaterEndMinute() => _box.read('waterEndMin') ?? 0;
  static Future<void> saveWaterEndMinute(int val) => _box.write('waterEndMin', val);

  static bool isWaterSmartStopEnabled() => _box.read('waterSmartStop') ?? true;
  static Future<void> saveWaterSmartStopEnabled(bool val) => _box.write('waterSmartStop', val);
}
