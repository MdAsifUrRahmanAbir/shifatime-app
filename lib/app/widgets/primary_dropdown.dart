import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// PrimaryDropdown — consistent dropdown used across all forms.
class PrimaryDropdown<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const PrimaryDropdown({
    super.key,
    this.label,
    required this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: AppSizes.fontSmall,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall - 2),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isDark
                ? AppColors.darkCardBackground
                : AppColors.greyLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMid,
              vertical: AppSizes.paddingSmall,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: BorderSide(
                color: isDark ? AppColors.greyDark : AppColors.greyLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
