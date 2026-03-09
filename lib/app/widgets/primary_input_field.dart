import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// PrimaryInputField — consistent text input used across all forms.
/// All styling driven by AppSizes and AppColors.
class PrimaryInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final int maxLines;
  final int? maxLength;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;

  const PrimaryInputField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
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
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: maxLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          style: TextStyle(
            fontSize: AppSizes.fontMedium,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: AppSizes.fontMedium,
              color: AppColors.textHint,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
