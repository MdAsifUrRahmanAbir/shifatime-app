import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // google_fonts 9.x's `outfitTextTheme()` uses `material_ui`'s TextTheme,
  // which is a different type from `package:flutter/material.dart`'s.
  // Apply Outfit to each style individually instead (TextStyle is shared).
  static TextTheme _outfitTextTheme(TextTheme t) => TextTheme(
        displayLarge: GoogleFonts.outfit(textStyle: t.displayLarge),
        displayMedium: GoogleFonts.outfit(textStyle: t.displayMedium),
        displaySmall: GoogleFonts.outfit(textStyle: t.displaySmall),
        headlineLarge: GoogleFonts.outfit(textStyle: t.headlineLarge),
        headlineMedium: GoogleFonts.outfit(textStyle: t.headlineMedium),
        headlineSmall: GoogleFonts.outfit(textStyle: t.headlineSmall),
        titleLarge: GoogleFonts.outfit(textStyle: t.titleLarge),
        titleMedium: GoogleFonts.outfit(textStyle: t.titleMedium),
        titleSmall: GoogleFonts.outfit(textStyle: t.titleSmall),
        bodyLarge: GoogleFonts.outfit(textStyle: t.bodyLarge),
        bodyMedium: GoogleFonts.outfit(textStyle: t.bodyMedium),
        bodySmall: GoogleFonts.outfit(textStyle: t.bodySmall),
        labelLarge: GoogleFonts.outfit(textStyle: t.labelLarge),
        labelMedium: GoogleFonts.outfit(textStyle: t.labelMedium),
        labelSmall: GoogleFonts.outfit(textStyle: t.labelSmall),
      );

  // --------------------
  // Light Theme
  // --------------------
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    cardColor: AppColors.cardBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: AppSizes.fontLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    textTheme: _outfitTextTheme(const TextTheme(
      displayLarge: TextStyle(
        fontSize: AppSizes.fontXLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: AppSizes.fontLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: AppSizes.fontMedium,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.fontSmall,
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: AppSizes.fontXS,
        color: AppColors.textHint,
      ),
    )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMid,
        vertical: AppSizes.paddingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.outfit(
        fontSize: AppSizes.fontMedium,
        color: AppColors.textHint,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: const BorderSide(color: AppColors.primary),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.outfit(fontSize: AppSizes.fontSmall),
      unselectedLabelStyle: GoogleFonts.outfit(fontSize: AppSizes.fontSmall),
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: AppSizes.fontLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      iconTheme: const IconThemeData(color: AppColors.textLight),
    ),
    textTheme: _outfitTextTheme(const TextTheme(
      displayLarge: TextStyle(
        fontSize: AppSizes.fontXLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      displayMedium: TextStyle(
        fontSize: AppSizes.fontLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      bodyLarge: TextStyle(
        fontSize: AppSizes.fontMedium,
        color: AppColors.textLight,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.fontSmall,
        color: AppColors.greyLight,
      ),
      bodySmall: TextStyle(fontSize: AppSizes.fontXS, color: AppColors.grey),
    )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyDark,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMid,
        vertical: AppSizes.paddingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.outfit(
        fontSize: AppSizes.fontMedium,
        color: AppColors.greyLight,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: const BorderSide(color: AppColors.primaryDark),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCardBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.outfit(fontSize: AppSizes.fontSmall),
      unselectedLabelStyle: GoogleFonts.outfit(fontSize: AppSizes.fontSmall),
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
