import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/services/local_storage_service.dart';
import 'app/core/theme/app_theme.dart';

class AppInitial {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ─── Init GetStorage (replaces SharedPreferences) ─────────────────────────
    await GetStorage.init();

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
