import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/services/local_storage_service.dart';
import 'app/core/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/data/models/medicine_model.dart';
import 'app/data/models/dose_record_model.dart';
import 'app/data/models/test_report_model.dart';
import 'app/data/models/test_parameter_model.dart';
import 'app/data/models/diabetes_record_model.dart';
import 'app/data/models/pressure_record_model.dart';
import 'app/core/services/notification_service.dart';
import 'app/core/services/ad_service.dart';

class AppInitial {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ─── Init GetStorage (replaces SharedPreferences) ─────────────────────────
    await GetStorage.init();

    // ─── Init Hive ────────────────────────────────────────────────────────────
    await Hive.initFlutter();
    Hive.registerAdapter(MedicineAdapter());
    Hive.registerAdapter(DoseRecordAdapter());
    Hive.registerAdapter(TestReportAdapter());
    Hive.registerAdapter(DiabetesRecordAdapter());
    Hive.registerAdapter(PressureRecordAdapter());
    Hive.registerAdapter(TestParameterAdapter());
    await Hive.openBox<Medicine>('medicines');
    await Hive.openBox<DoseRecord>('dose_records');
    await Hive.openBox('activity_logs');
    await Hive.openBox<TestReport>('test_reports');
    await Hive.openBox<DiabetesRecord>('diabetes_records');
    await Hive.openBox<PressureRecord>('pressure_records');

    // ─── Init Notifications (timezone + channels + plugin) ────────────────────
    // Must be called BEFORE runApp so zonedSchedule() works correctly.
    await NotificationService.init();

    // ─── AdMob (consent + SDK init) ───────────────────────────────────────────
    // Not awaited: ads must never delay startup or alarm handling.
    AdService.init();

    // ─── System UI ────────────────────────────────────────────────────────────
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // ─── Apply saved theme ────────────────────────────────────────────────────
    AppTheme.themeMode = LocalStorage.isDarkMode()
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
