import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/text_widget.dart';

class ProfileInfoCardWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDark;

  const ProfileInfoCardWidget({
    super.key,
    required this.title,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: TextWidget.titleSmall(
            title,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardBackground
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            // boxShadow: [
            //   BoxShadow(
            //     color: AppColors.shadow,
            //     blurRadius: 10,
            //     offset: const Offset(0, 4),
            //   ),
            // ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class ProfileInfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRowWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.badgeXS(label, color: AppColors.textSecondary),
                const SizedBox(height: 2),
                TextWidget.bodySmall(value, fontWeight: FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
