import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/water_intake_controller.dart';

class WaterWeeklyChart extends StatelessWidget {
  const WaterWeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WaterIntakeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final totals = controller.weeklyTotals;
      final target = controller.targetMl.value > 0 ? controller.targetMl.value : 1.0;
      final now = DateTime.now();

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
                    Row(
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
                    ),
                  ],
                ),
                Text(
                  'Target: ${controller.targetMl.value.toInt()} ml',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bars Row — last 7 real days of intake, ending with today.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final dayOffset = 6 - index;
                final date = now.subtract(Duration(days: dayOffset));
                final total = index < totals.length ? totals[index] : 0.0;
                final pct = ((total / target) * 100).round();
                final isHighlighted = dayOffset == 0;
                final dayLabel = DateFormat('EEE').format(date).substring(0, 3);

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
                      dayLabel,
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
    });
  }
}
