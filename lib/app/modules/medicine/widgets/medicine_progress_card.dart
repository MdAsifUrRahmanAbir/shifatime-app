import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../water_intake/controllers/water_intake_controller.dart';

class MedicineProgressCard extends StatelessWidget {
  final WaterIntakeController waterCtrl;

  const MedicineProgressCard({super.key, required this.waterCtrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double progress = waterCtrl.targetMl.value > 0
          ? (waterCtrl.consumedMl.value / waterCtrl.targetMl.value).clamp(0.0, 1.0)
          : 0.0;
      final int percent = (progress * 100).toInt();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.limeAccent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, color: AppColors.limeDarkText, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Daily intake',
                        style: GoogleFonts.outfit(
                          color: AppColors.limeDarkText.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Weekly\nProgress',
                    style: GoogleFonts.outfit(
                      color: AppColors.limeDarkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Right side circular progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 9,
                    backgroundColor: Colors.white.withValues(alpha: 0.35),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                Text(
                  '$percent%',
                  style: GoogleFonts.outfit(
                    color: AppColors.limeDarkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
