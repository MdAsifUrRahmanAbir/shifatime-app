import 'package:flutter/material.dart';

/// Responsive helper - use to detect screen type and build adaptive layouts.
class ResponsiveHelper {
  ResponsiveHelper._();

  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _tabletBreakpoint;

  /// Build different UI based on screen size.
  static Widget builder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}
