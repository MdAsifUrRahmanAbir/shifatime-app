import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// Remitium-style responsive layout widget.
///
/// Wraps its children in a LayoutBuilder and selects the right scaffold
/// based on the device width breakpoints defined in AppSizes.
///
/// Usage:
///   return ResponsiveLayout(
///     mobile: _MobileLayout(),
///     tablet: _TabletLayout(),   // optional, falls back to mobile
///     desktop: _DesktopLayout(), // optional, falls back to mobile
///   );
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppSizes.mobileBreakpoint) {
          return mobile;
        } else if (constraints.maxWidth < AppSizes.tabletBreakpoint) {
          return tablet ?? mobile;
        } else {
          return desktop ?? mobile;
        }
      },
    );
  }
}

/// Utility: check current device category anywhere (without LayoutBuilder)
class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= AppSizes.mobileBreakpoint && w < AppSizes.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppSizes.tabletBreakpoint;
}
