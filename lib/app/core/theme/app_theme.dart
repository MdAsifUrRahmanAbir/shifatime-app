import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';


class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // --------------------
  // Light Theme
  // --------------------
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    cardColor: AppColors.cardBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: AppSizes.fontLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      iconTheme: const IconThemeData(color: AppColors.textLight),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: AppSizes.fontXLarge, color: AppColors.textPrimary),
      displayMedium: TextStyle(fontSize: AppSizes.fontLarge, color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontSize: AppSizes.fontMedium, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: AppSizes.fontSmall, color: AppColors.textSecondary),
      bodySmall: TextStyle(fontSize: AppSizes.fontXS, color: AppColors.textHint),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMid,
        vertical: AppSizes.paddingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(fontSize: AppSizes.fontMedium, color: AppColors.textHint),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        textStyle: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        side: const BorderSide(color: AppColors.primary),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: AppSizes.fontSmall),
      unselectedLabelStyle: TextStyle(fontSize: AppSizes.fontSmall),
    ),
  );

  // --------------------
  // Dark Theme
  // --------------------
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
    cardColor: AppColors.darkCardBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: AppSizes.fontLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      iconTheme: const IconThemeData(color: AppColors.textLight),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: AppSizes.fontXLarge, color: AppColors.textLight),
      displayMedium: TextStyle(fontSize: AppSizes.fontLarge, color: AppColors.textLight),
      bodyLarge: TextStyle(fontSize: AppSizes.fontMedium, color: AppColors.textLight),
      bodyMedium: TextStyle(fontSize: AppSizes.fontSmall, color: AppColors.greyLight),
      bodySmall: TextStyle(fontSize: AppSizes.fontXS, color: AppColors.grey),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyDark,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMid,
        vertical: AppSizes.paddingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(fontSize: AppSizes.fontMedium, color: AppColors.greyLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        textStyle: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        side: BorderSide(color: AppColors.primaryDark),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCardBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: AppSizes.fontSmall),
      unselectedLabelStyle: TextStyle(fontSize: AppSizes.fontSmall),
    ),
  );

  // --------------------
  // Global method to switch theme dynamically
  // --------------------
  static ThemeMode themeMode = ThemeMode.light;

  static void updateTheme(ThemeMode mode) {
    themeMode = mode;
  }
}
