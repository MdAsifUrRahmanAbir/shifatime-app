import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';

class MenuMainGrid extends StatelessWidget {
  final bool isDark;
  final ProfileController profileCtrl;
  final VoidCallback onInventoryTap;
  final VoidCallback onAchievementsTap;
  final VoidCallback onThemeToggle;

  const MenuMainGrid({
    super.key,
    required this.isDark,
    required this.profileCtrl,
    required this.onInventoryTap,
    required this.onAchievementsTap,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // User profile snippet card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.limeAccent, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=shifatime_user',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            profileCtrl.name.value.isNotEmpty ? profileCtrl.name.value : 'Sajibur Rahman',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          )),
                      const SizedBox(height: 4),
                      Text(
                        'Offline Personal Health Profile',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onPressed: () => Get.toNamed(Routes.profile),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Menu Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.15,
            children: [
              _buildMenuCard(
                isDark,
                'Health Profile',
                'View BMI & suggestions',
                Icons.person_pin_rounded,
                Colors.blue,
                () => Get.toNamed(Routes.profile),
              ),
              _buildMenuCard(
                isDark,
                'Stock Inventory',
                'Manage remaining pills',
                Icons.inventory_2_rounded,
                Colors.orange,
                onInventoryTap,
              ),
              _buildMenuCard(
                isDark,
                'Achievements',
                'Streak logs & awards',
                Icons.stars_rounded,
                Colors.amber,
                onAchievementsTap,
              ),
              _buildMenuCard(
                isDark,
                'Alarm Settings',
                'Sounds & repeat intervals',
                Icons.notifications_active_rounded,
                Colors.deepOrangeAccent,
                () => Get.toNamed(Routes.notificationSettings),
              ),
              _buildMenuCard(
                isDark,
                'Reminder History',
                'Logs of medicine & water',
                Icons.history_rounded,
                Colors.teal,
                () => Get.toNamed(Routes.reminderHistory),
              ),
              _buildMenuCard(
                isDark,
                isDark ? 'Light Mode' : 'Dark Mode',
                'Toggle system theme',
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                Colors.purple,
                onThemeToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    bool isDark,
    String title,
    String desc,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
