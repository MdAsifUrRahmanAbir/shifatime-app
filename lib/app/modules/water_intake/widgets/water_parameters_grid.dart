import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/water_intake_controller.dart';
import 'sparkline_painter.dart';

class WaterParametersGrid extends StatelessWidget {
  const WaterParametersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WaterIntakeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Left Parameter Card: Logs Summary
        Expanded(
          child: Obx(() {
            final double progress = controller.targetMl.value > 0
                ? (controller.consumedMl.value / controller.targetMl.value)
                : 0.0;
            final percent = (progress * 100).toInt().clamp(0, 100);

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hydration',
                        style: GoogleFonts.outfit(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$percent%',
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'completed',
                    style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Small waveform illustration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(12, (index) {
                      final heights = [14.0, 8.0, 22.0, 12.0, 18.0, 6.0, 16.0, 26.0, 10.0, 14.0, 20.0, 8.0];
                      return Container(
                        width: 3,
                        height: heights[index],
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(width: 14),

        // Right Parameter Card: Logs List count
        Expanded(
          child: Obx(() {
            final logCount = controller.logs.length;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Drinks',
                        style: GoogleFonts.outfit(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.opacity_rounded, color: Colors.blueAccent, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$logCount logs',
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'saved today',
                    style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Flat wave line decoration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomPaint(
                          size: const Size(double.infinity, 18),
                          painter: SparklinePainter(isDark: isDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
