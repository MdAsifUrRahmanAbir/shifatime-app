import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../widgets/water_intake_body.dart';

class WaterIntakeView extends StatefulWidget {
  const WaterIntakeView({super.key});

  @override
  State<WaterIntakeView> createState() => _WaterIntakeViewState();
}

class _WaterIntakeViewState extends State<WaterIntakeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Statistic',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
            onPressed: () {
              Get.snackbar(
                'Water Logs 💧',
                'Keep logging to view monthly patterns.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const ResponsiveLayout(mobile: WaterIntakeBody()),
    );
  }
}
