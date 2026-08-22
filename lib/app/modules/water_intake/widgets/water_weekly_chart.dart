import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/water_intake_controller.dart';

class WaterWeeklyChart extends StatelessWidget {
  const WaterWeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WaterIntakeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Mock percentages for the week to match mockup screen 2:
    final percentages = [44, 34, 110, 47, 32, 79, 24];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(28),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water Intake',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${controller.consumedMl.value.toInt()}',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ml',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              Obx(() => Text(
                    'Target: ${controller.targetMl.value.toInt()} ml',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 24),

          // Bars Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final day = weekdays[index];
              final pct = percentages[index];
              final isHighlighted = index == 2; // Wednesday highlighted

              // Max bar height = 130
              final barHeight = (pct / 120.0 * 120.0).clamp(10.0, 120.0);

              return Column(
                children: [
                  Text(
                    '$pct%',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                      color: isHighlighted
                          ? AppColors.primary
                          : (isDark ? Colors.white30 : Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 14,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? AppColors.primary
                          : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.15)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                      color: isHighlighted
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
