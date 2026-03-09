import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// RichTextWidget — for mixed-style text like "Don't have an account? Sign Up"
class RichTextWidget extends StatelessWidget {
  final String normalText;
  final String highlightText;
  final VoidCallback? onTap;
  final Color? highlightColor;
  final double? fontSize;
  final MainAxisAlignment alignment;

  const RichTextWidget({
    super.key,
    required this.normalText,
    required this.highlightText,
    this.onTap,
    this.highlightColor,
    this.fontSize,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Text(
          normalText,
          style: TextStyle(
            fontSize: fontSize ?? AppSizes.fontSmall,
            color: isDark ? AppColors.greyLight : AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            highlightText,
            style: TextStyle(
              fontSize: fontSize ?? AppSizes.fontSmall,
              fontWeight: FontWeight.w700,
              color: highlightColor ?? AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
