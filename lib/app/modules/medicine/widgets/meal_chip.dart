import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class MealChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const MealChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Icon(icon, color: isSelected ? AppColors.limeDarkText : Colors.grey[600], size: 18),
      label: Text(label, style: GoogleFonts.outfit(fontSize: 12)),
      selected: isSelected,
      selectedColor: AppColors.limeAccent,
      backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
      labelStyle: GoogleFonts.outfit(
        color: isSelected ? AppColors.limeDarkText : (isDark ? Colors.white70 : AppColors.textPrimary),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppColors.limeAccent : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      onSelected: onSelected,
    );
  }
}
