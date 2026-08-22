import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class MedicineCalendarBar extends StatelessWidget {
  const MedicineCalendarBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final dates = ['07', '08', '09', '10', '11', '12', '13'];
    final selectedIdx = 3; // "W 10" highlighted like in mockup

    // Month header
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'August 2025',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                _buildCalArrow(isDark, Icons.arrow_back_ios_new_rounded),
                const SizedBox(width: 8),
                _buildCalArrow(isDark, Icons.arrow_forward_ios_rounded),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Date row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(days.length, (index) {
            final isSelected = index == selectedIdx;
            return isSelected
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.limeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          days[index],
                          style: GoogleFonts.outfit(
                            color: AppColors.limeDarkText,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dates[index],
                          style: GoogleFonts.outfit(
                            color: AppColors.limeDarkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Text(
                          days[index],
                          style: GoogleFonts.outfit(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dates[index],
                          style: GoogleFonts.outfit(
                            color: isDark ? Colors.white70 : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ],
    );
  }

  Widget _buildCalArrow(bool isDark, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: 10,
        color: isDark ? Colors.white70 : AppColors.textPrimary,
      ),
    );
  }
}
