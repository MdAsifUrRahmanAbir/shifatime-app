import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class TimeSlotChip extends StatelessWidget {
  final String value;
  final String display;
  final IconData icon;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotChip({
    super.key,
    required this.value,
    required this.display,
    required this.icon,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.limeAccent : (isDark ? AppColors.darkCardBackground : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.limeAccent : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.limeDarkText : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                display,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.limeDarkText : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
