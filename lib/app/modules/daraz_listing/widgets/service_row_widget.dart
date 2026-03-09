import 'package:flutter/material.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class ServiceRowWidget extends StatelessWidget {
  const ServiceRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXSmall),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ServiceItem(icon: Icons.lock_outline, label: AppStrings.safePayment),
          _VerticalDivider(),
          _ServiceItem(
            icon: Icons.local_shipping_outlined,
            label: AppStrings.fastDelivery,
          ),
          _VerticalDivider(),
          _ServiceItem(
            icon: Icons.replay_outlined,
            label: AppStrings.freeReturn,
          ),
        ],
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ServiceItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        TextWidget.bodySmall(label, color: AppColors.textSecondary),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 14, width: 1, color: AppColors.divider);
}
