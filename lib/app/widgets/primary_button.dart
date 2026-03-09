import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// PrimaryButton — the main CTA button used across all screens.
/// Fully consistent height, radius, and font from AppSizes.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final Color? textColor;
  final double? width;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.textColor,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    final fg = textColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: AppSizes.buttonHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: bg, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
              ),
              child: _buildChild(context, bg),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                disabledBackgroundColor: bg.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                elevation: 0,
              ),
              child: _buildChild(context, fg),
            ),
    );
  }

  Widget _buildChild(BuildContext context, Color color) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppColors.primary : Colors.white,
          ),
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSizes.iconSmall, color: color),
          const SizedBox(width: AppSizes.gapXSmall),
          Text(
            text,
            style: TextStyle(
              fontSize: AppSizes.fontMedium,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: AppSizes.fontMedium,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

/// SecondaryButton — text-style button for less prominent actions.
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }
}
