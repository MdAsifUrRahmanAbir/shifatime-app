import 'package:flutter/material.dart';

class AppColors {
  // --------------------
  // Brand / Daraz Colors
  // --------------------
  static const Color primary = Color(0xFFFF6000); // Daraz Orange
  static const Color primaryDark = Color(0xFFE05200);
  static const Color primaryLight = Color(0xFFFF8C00);

  static const Color bg = Color(0xFFF5F5F5); // Daraz Background
  static const Color yellow = Color(0xFFFFC200); // Daraz Yellow

  static const Color accent = Color(0xFFFFC107);
  static const Color accentLight = Color(0xFFFFF350);
  static const Color accentDark = Color(0xFFC79100);

  // --------------------
  // Background / Scaffold
  // --------------------
  static const Color scaffoldBackground = Color(0xFFF5F6FA);
  static const Color cardBackground = Colors.white;
  static const Color darkScaffoldBackground = Color(0xFF1C1C1E);
  static const Color darkCardBackground = Color(0xFF2C2C2E);

  // --------------------
  // Text Colors
  // --------------------
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textLight = Colors.white;

  // --------------------
  // Status Colors
  // --------------------
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // --------------------
  // Grey Shades
  // --------------------
  static const Color greyLight = Color(0xFFEEEEEE);
  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyDark = Color(0xFF616161);

  // --------------------
  // Optional Semantic / Extra
  // --------------------
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x29000000);
  static const Color transparent = Colors.transparent;

  // --------------------
  // Dynamic Theme Colors (for AppTheme)
  // --------------------
  static Color background(bool isDark) =>
      isDark ? darkScaffoldBackground : scaffoldBackground;

  static Color card(bool isDark) =>
      isDark ? darkCardBackground : cardBackground;

  static Color textPrimaryColor(bool isDark) =>
      isDark ? Colors.white : textPrimary;

  static Color textSecondaryColor(bool isDark) =>
      isDark ? greyLight : textSecondary;
}
