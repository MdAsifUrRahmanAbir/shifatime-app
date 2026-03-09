import 'package:flutter/material.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class VoucherStripWidget extends StatelessWidget {
  const VoucherStripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.only(top: AppSizes.gapXSmall),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.paddingSmall,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.titleMedium('4%OFF', color: AppColors.primary),
                TextWidget.bodySmall(
                  AppStrings.voucherMax,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Container(height: 30, width: 1, color: AppColors.divider),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.gapSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget.titleMedium('৳110', color: AppColors.primary),
                  TextWidget.bodySmall(
                    AppStrings.freeShipping,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSmall + 2,
              vertical: AppSizes.paddingXSmall - 1,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            ),
            child: TextWidget.titleSmall(
              AppStrings.collect,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
