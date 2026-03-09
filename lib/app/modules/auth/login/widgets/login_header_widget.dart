import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  final bool isDark;
  const LoginHeaderWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSizes.gapXXLarge),
        Text(
          AppStrings.welcomeBack,
          style: TextStyle(
            fontSize: AppSizes.fontXXXLarge,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSizes.gapXSmall),
        const Text(
          AppStrings.signInToContinue,
          style: TextStyle(
            fontSize: AppSizes.fontMedium,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSizes.gapXXLarge),
      ],
    );
  }
}
