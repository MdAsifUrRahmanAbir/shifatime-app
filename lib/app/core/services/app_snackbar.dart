import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

/// Centralised snackbar utility — Remitium's CustomSnackBar pattern adapted.
///
/// Usage:
///   AppSnackBar.success('Profile updated!');
///   AppSnackBar.error('Invalid email address.');
///   AppSnackBar.info('Downloading...');
class AppSnackBar {
  AppSnackBar._();

  static void success(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      leftBarIndicatorColor: Colors.white,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
      mainButton: TextButton(
        onPressed: Get.back,
        child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  static void error(String message) {
    Get.snackbar(
      'Alert',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      leftBarIndicatorColor: AppColors.error,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 8,
      icon: const Icon(Icons.warning_rounded, color: Colors.white),
      mainButton: TextButton(
        onPressed: Get.back,
        child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  static void info(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 8,
      icon: const Icon(Icons.info_rounded, color: Colors.white),
    );
  }

  static void warning(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 8,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
    );
  }
}
