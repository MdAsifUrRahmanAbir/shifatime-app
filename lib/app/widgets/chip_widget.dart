import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// ChipWidget — label chip for tags, categories, filter pills.
class ChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const ChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selColor = selectedColor ?? AppColors.primary;
    final unselColor =
        unselectedColor ?? (isDark ? AppColors.greyDark : AppColors.greyLight);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSmall,
          vertical: AppSizes.paddingXSmall - 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selColor : unselColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          border: Border.all(
            color: isSelected ? selColor : AppColors.grey,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontXS,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textLight : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
