import 'package:flutter/material.dart';

/// Centralized App Sizes for padding, margins, font sizes, radius, heights, widths.
/// Update here and it applies globally across all screens and widgets.
class AppSizes {
  AppSizes._(); // Private constructor

  // --------------------
  // Responsive Breakpoints (matches Remitium Dimensions)
  // --------------------
  static const double mobileBreakpoint = 575.0;
  static const double tabletBreakpoint = 1100.0;

  // --------------------
  // Font Sizes
  // --------------------
  static const double fontXXXLarge = 32.0;
  static const double fontXXLarge = 28.0;
  static const double fontXLarge = 24.0;
  static const double fontLarge = 20.0;
  static const double fontMedium = 16.0;
  static const double fontSmall = 14.0;
  static const double fontXS = 12.0;

  // --------------------
  // Padding & Margin
  // --------------------
  static const double paddingXLarge = 32.0;
  static const double paddingLarge = 24.0;
  static const double paddingMid = 16.0;
  static const double paddingSmall = 12.0;
  static const double paddingXSmall = 8.0;

  static const double marginXLarge = 32.0;
  static const double marginLarge = 24.0;
  static const double marginMid = 16.0;
  static const double marginSmall = 12.0;
  static const double marginXSmall = 8.0;

  // --------------------
  // Radius / Border Radius
  // --------------------
  static const double radiusXLarge = 32.0;
  static const double radiusLarge = 24.0;
  static const double radiusMid = 16.0;
  static const double radiusSmall = 12.0;
  static const double radius = 8.0;
  static const double radiusXSmall = 4.0;

  // --------------------
  // Gaps / Spacing between widgets
  // --------------------
  static const double gapXXLarge = 32.0;
  static const double gapXLarge = 24.0;
  static const double gapLarge = 20.0;
  static const double gapMid = 16.0;
  static const double gapSmall = 12.0;
  static const double gapXSmall = 8.0;

  // --------------------
  // Icon Sizes
  // --------------------
  static const double iconXXLarge = 48.0;
  static const double iconXLarge = 36.0;
  static const double iconLarge = 28.0;
  static const double iconMid = 24.0;
  static const double iconSmall = 20.0;
  static const double iconXSmall = 16.0;

  // --------------------
  // Specific Component Sizes
  // --------------------
  static const double logoSize = 96.0;
  static const double progressIndicatorSize = 24.0;
  static const double indicatorStrokeWidth = 2.5;
  static const double splashBottomGap = 64.0;
  static const double iconExtraLarge = 52.0;

  // --------------------
  // Button / Input Sizes
  // --------------------
  static const double buttonHeight = 48.0;
  static const double inputFieldHeight = 48.0;

  // --------------------
  // Screen Specific Sizes (optional, responsive)
  // --------------------
  static double screenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return paddingXLarge; // Desktop
    if (width >= 800) return paddingLarge; // Tablet
    return paddingMid; // Mobile
  }

  static double screenRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return radiusXLarge; // Desktop
    if (width >= 800) return radiusLarge; // Tablet
    return radius; // Mobile
  }

  static double screenGap(
    BuildContext context, {
    double? small,
    double? mid,
    double? large,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return large ?? gapXLarge; // Desktop
    if (width >= 800) return mid ?? gapMid; // Tablet
    return small ?? gapSmall; // Mobile
  }
}
