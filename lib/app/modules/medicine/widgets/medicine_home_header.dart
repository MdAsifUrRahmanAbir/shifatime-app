import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';

class MedicineHomeHeader extends StatelessWidget {
  final ProfileController profileCtrl;

  const MedicineHomeHeader({super.key, required this.profileCtrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: User Avatar + Greeter
          GestureDetector(
            onTap: () => Get.toNamed(Routes.profile),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.limeAccent, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=shifatime_user',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning!',
                      style: GoogleFonts.outfit(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(() => Text(
                          profileCtrl.name.value.isNotEmpty
                              ? profileCtrl.name.value
                              : 'Sajibur Rahman',
                          style: GoogleFonts.outfit(
                            color: isDark ? Colors.white : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),

          // Right side: Calendar & Notification icons
          Row(
            children: [
              _buildHeaderIconButton(
                context,
                Icons.calendar_today_outlined,
                onTap: () => Get.toNamed(Routes.waterIntake), // Statistics Screen
              ),
              const SizedBox(width: 12),
              _buildHeaderIconButton(
                context,
                Icons.notifications_none_outlined,
                hasDot: true,
                onTap: () {
                  Get.snackbar(
                    'Notifications 🔔',
                    'All scheduled medicine reminders are active!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton(BuildContext context, IconData icon, {bool hasDot = false, VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          if (hasDot)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
