import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// PrimaryAppBar — consistent AppBar used across all screens.
/// Title, leading icon, and actions follow a unified style.
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool centerTitle;
  final Widget? leading;

  const PrimaryAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.centerTitle = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        backgroundColor ??
        (isDark
            ? AppColors.darkScaffoldBackground
            : AppColors.scaffoldBackground);
    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading:
          leading ??
          (showBack
              ? IconButton(
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: AppSizes.iconXSmall + 2,
                      color: isDark
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                    ),
                  ),
                  onPressed:
                      onBackPressed ?? () => Navigator.of(context).maybePop(),
                )
              : null),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.fontLarge,
          fontWeight: FontWeight.w700,
          color:
              titleColor ??
              (isDark ? AppColors.textLight : AppColors.textPrimary),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
