import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/primary_input_field.dart';
import '../controllers/login_controller.dart';

class LoginFormWidget extends GetView<LoginController> {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username field
          PrimaryInputField(
            label: AppStrings.username,
            hint: AppStrings.usernameHint,
            controller: controller.usernameCtrl,
            validator: controller.validateUsername,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: AppSizes.gapMid),

          // Password field
          Obx(
            () => PrimaryInputField(
              label: AppStrings.password,
              hint: AppStrings.passwordHint,
              controller: controller.passwordCtrl,
              obscureText: !controller.isPasswordVisible.value,
              validator: controller.validatePassword,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.textHint,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textHint,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.gapXXLarge),

          // Login button
          Obx(
            () => PrimaryButton(
              text: AppStrings.signIn,
              isLoading: controller.isLoading.value,
              onPressed: controller.login,
            ),
          ),
        ],
      ),
    );
  }
}
