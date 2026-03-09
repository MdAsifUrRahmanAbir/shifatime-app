import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/text_widget.dart';
import '../controllers/profile_controller.dart';
import '../model/user_model.dart';

class ProfileHeaderWidget extends GetView<ProfileController> {
  final VoidCallback onLogout;
  final UserModel? user;

  const ProfileHeaderWidget({super.key, required this.onLogout, this.user});

  @override
  Widget build(BuildContext context) {
    final displayUser = user ?? controller.user.value ?? UserModel.dummy();

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
      ),
      actions: [
        Obx(() {
          if (controller.isLoggingOut.value) {
            return const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            );
          }
          return IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
          );
        }),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSizes.gapMid),
                // Avatar
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSizes.gapSmall),
                TextWidget.headlineMedium(
                  displayUser.fullName,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                TextWidget.bodySmall(
                  displayUser.email ?? '',
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
