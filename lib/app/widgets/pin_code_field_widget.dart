import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class PinCodeFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final void Function(String)? onChanged;
  final double? width;
  final double? height;
  final bool obscureText;

  const PinCodeFieldWidget({
    super.key,
    required this.controller,
    this.length = 6,
    this.onChanged,
    this.width,
    this.height,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width ?? AppSizes.inputFieldHeight,
      height: height ?? AppSizes.inputFieldHeight,
      textStyle: TextStyle(
        fontSize: AppSizes.fontLarge,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: AppColors.grey),
      ),
    );

    return Pinput(
      controller: controller,
      length: length,
      obscureText: obscureText,
      defaultPinTheme: defaultPinTheme,
      onChanged: onChanged ?? (_) {},
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(color: AppColors.primary),
        ),
      ),
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 2,
            height: 20,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
