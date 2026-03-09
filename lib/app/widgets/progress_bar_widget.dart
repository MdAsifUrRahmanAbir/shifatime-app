import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// ProgressBarWidget — labeled progress indicator for tasks, profiles, etc.
class ProgressBarWidget extends StatelessWidget {
  final String? label;
  final double value; // 0.0 to 1.0
  final Color? color;
  final double height;
  final bool showPercentage;

  const ProgressBarWidget({
    super.key,
    this.label,
    required this.value,
    this.color,
    this.height = 8.0,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = color ?? AppColors.primary;
    final percentage = (value * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: AppSizes.fontXS,
                    fontWeight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
            ],
          ),
        if (label != null || showPercentage)
          const SizedBox(height: AppSizes.gapXSmall - 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: value,
            minHeight: height,
            backgroundColor: isDark ? AppColors.greyDark : AppColors.greyLight,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
