import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../widgets/health_tips_body.dart';

class HealthTipsView extends StatelessWidget {
  const HealthTipsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Health Library',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const ResponsiveLayout(mobile: HealthTipsBody()),
      bottomNavigationBar: const AppBottomNavBar(current: AppNavTab.blog),
    );
  }
}
