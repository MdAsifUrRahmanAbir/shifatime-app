import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app_initial.dart';

Future<void> main() async {
  await AppInitial.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.themeMode,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
    );
  }
}
