import 'package:flutter/material.dart';

class AppColors {
  // --------------------
  // Brand / Premium Colors
  // --------------------
  static const Color primary = Color(0xFF2FAC66); // ShifaTime Green
  static const Color primaryDark = Color(0xFF1E7D4A);
  static const Color primaryLight = Color(0xFF2FAC66);

  static const Color limeAccent = Color(0xFFC9F2A5); // Mockup Lime Green
  static const Color limeDarkText = Color(0xFF1A300E); // Dark text on lime accent

  static const Color bg = Color(0xFFF7F8FA);
  static const Color yellow = Color(0xFFFFC200);

  static const Color accent = Color(0xFFFFC107);
  static const Color accentLight = Color(0xFFFFF350);
  static const Color accentDark = Color(0xFFC79100);

  // --------------------
  // Background / Scaffold
  // --------------------
  static const Color scaffoldBackground = Color(0xFFF7F8FA);
  static const Color cardBackground = Colors.white;
  static const Color darkScaffoldBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  // --------------------
  // Text Colors
  // --------------------
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF70757A);
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
  static const Color greyLight = Color(0xFFF5F6F8);
  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyDark = Color(0xFF2C2C2E);

  // --------------------
  // Optional Semantic / Extra
  // --------------------
  static const Color divider = Color(0xFFEFEFEF);
  static const Color shadow = Color(0x0A000000); // Sleek soft shadow
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
