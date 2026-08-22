import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../routes/app_pages.dart';

/// Which tab of the shared bottom nav bar is currently active.
enum AppNavTab { home, progress, add, blog, menu }

/// Shared Home/Progress/Add/Blog/Menu bottom navigation bar used by every
/// tab-root screen (medicine home, health tips, menu).
class AppBottomNavBar extends StatelessWidget {
  final AppNavTab current;

  const AppBottomNavBar({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNavBarItem(
              context,
              Icons.home_rounded,
              'Home',
              isSelected: current == AppNavTab.home,
              onTap: () => Get.offAllNamed(Routes.medicine),
            ),
          ),
          Expanded(
            child: _buildNavBarItem(
              context,
              Icons.analytics_outlined,
              'Progress',
              isSelected: current == AppNavTab.progress,
              onTap: () => Get.offAllNamed(Routes.waterIntake),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.addMedicine),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.limeAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.limeAccent.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.limeDarkText,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildNavBarItem(
              context,
              Icons.library_books_outlined,
              'Blog',
              isSelected: current == AppNavTab.blog,
              onTap: () => Get.offAllNamed(Routes.healthTips),
            ),
          ),
          Expanded(
            child: _buildNavBarItem(
              context,
              Icons.menu_rounded,
              'Menu',
              isSelected: current == AppNavTab.menu,
              onTap: () => Get.offAllNamed(Routes.menu),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isSelected ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.grey[400],
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
