import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/services/local_storage_service.dart';
import 'app/core/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'app/data/models/medicine_model.dart';
import 'app/core/services/notification_service.dart';

class AppInitial {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ─── Init GetStorage (replaces SharedPreferences) ─────────────────────────
    await GetStorage.init();

    // ─── Init Hive ────────────────────────────────────────────────────────────
    await Hive.initFlutter();
    Hive.registerAdapter(MedicineAdapter());
    await Hive.openBox<Medicine>('medicines');

    // ─── Init Notifications ───────────────────────────────────────────────────
    await NotificationService.init();

    // ─── Init Alarm Manager ───────────────────────────────────────────────────
    await AndroidAlarmManager.initialize();

    // ─── System UI ────────────────────────────────────────────────────────────
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // ─── Firebase (uncomment when firebase is configured) ─────────────────────
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // ─── Permanent services ───────────────────────────────────────────────────
    // Get.put(FirebaseService(), permanent: true);

    // ─── Apply saved theme ────────────────────────────────────────────────────
    AppTheme.themeMode = LocalStorage.isDarkMode()
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
