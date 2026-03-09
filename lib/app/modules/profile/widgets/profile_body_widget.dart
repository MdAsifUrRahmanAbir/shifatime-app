import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/profile_controller.dart';
import '../model/user_model.dart';
import 'profile_info_card_widget.dart';

class ProfileBodyWidget extends StatelessWidget {
  final ProfileController controller;
  final UserModel user;
  final bool isDark;
  final VoidCallback onLogout;

  const ProfileBodyWidget({
    super.key,
    required this.controller,
    required this.user,
    required this.isDark,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: AppSizes.gapSmall),
          // Information Sections
          ProfileInfoCardWidget(
            title: AppStrings.accountInfo,
            isDark: isDark,
            children: [
              ProfileInfoRowWidget(
                icon: Icons.alternate_email_rounded,
                label: AppStrings.username,
                value: user.username ?? '',
              ),
              ProfileInfoRowWidget(
                icon: Icons.phone_android_rounded,
                label: AppStrings.phone,
                value: user.phone ?? '',
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          ProfileInfoCardWidget(
            title: AppStrings.addressDetails,
            isDark: isDark,
            children: [
              ProfileInfoRowWidget(
                icon: Icons.location_on_outlined,
                label: AppStrings.street,
                value: '${user.address?.number} ${user.address?.street}',
              ),
              ProfileInfoRowWidget(
                icon: Icons.location_city_outlined,
                label: AppStrings.city,
                value: user.address?.city ?? '',
              ),
              ProfileInfoRowWidget(
                icon: Icons.mark_as_unread_outlined,
                label: AppStrings.zipCode,
                value: user.address?.zipcode ?? '',
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          ProfileInfoCardWidget(
            title: AppStrings.geolocation,
            isDark: isDark,
            children: [
              ProfileInfoRowWidget(
                icon: Icons.explore_outlined,
                label: AppStrings.latitude,
                value: user.address?.geolocation?.lat ?? '',
              ),
              ProfileInfoRowWidget(
                icon: Icons.explore_outlined,
                label: AppStrings.longitude,
                value: user.address?.geolocation?.long ?? '',
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapLarge),

          // Logout Button with Circular Loading
          Obx(
            () => PrimaryButton(
              text: AppStrings.logout,
              color: AppColors.error,
              icon: Icons.logout_rounded,
              isLoading: controller.isLoggingOut.value,
              onPressed: onLogout,
            ),
          ),
          const SizedBox(height: AppSizes.gapXLarge),
        ]),
      ),
    );
  }
}
