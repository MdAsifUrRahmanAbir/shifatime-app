import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/text_widget.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_body_widget.dart';
import '../model/user_model.dart';
import '../../../core/utils/shimmer_extension.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffoldBackground
          : AppColors.scaffoldBackground,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final user = controller.user.value;

        if (user == null && !isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget.body(AppStrings.failedToLoadProfile),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: AppStrings.retry,
                  onPressed: controller.fetchUserProfile,
                ),
              ],
            ),
          );
        }

        final displayUser = user ?? UserModel.dummy();

        return CustomScrollView(
          slivers: [
            // Profile Header
            ProfileHeaderWidget(
              user: displayUser,
              onLogout: () => _showLogoutDialog(context),
            ),

            // Use the abstracted body widget for info list and cards
            ProfileBodyWidget(
              controller: controller,
              user: displayUser,
              isDark: isDark,
              onLogout: () => _showLogoutDialog(context),
            ),
          ],
        ).skeletonizer(enabled: isLoading);
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: AppStrings.logout,
      middleText: AppStrings.logoutConfirm,
      textConfirm: AppStrings.yes,
      textCancel: AppStrings.cancel,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }
}
