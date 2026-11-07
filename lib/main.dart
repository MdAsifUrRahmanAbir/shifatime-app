import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/landing/landing_app.dart';
import 'app/routes/app_pages.dart';
import 'app_initial.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // ─── Web: show the download landing page only ─────────────────────────────
  // Alarms, notifications and Hive storage are mobile features, so the
  // browser build never runs AppInitial or the reminder app.
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const LandingApp());
    return;
  }

  await AppInitial.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShifaTime',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.themeMode,

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,

      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
