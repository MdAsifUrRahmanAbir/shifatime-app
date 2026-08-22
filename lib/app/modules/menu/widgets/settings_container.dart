import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsContainer extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const SettingsContainer({super.key, required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(children: children),
    );
  }
}
