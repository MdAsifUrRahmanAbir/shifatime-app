import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/app_snackbar.dart';
import '../../../../routes/app_pages.dart';
import '../model/login_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/app_endpoint.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController(text: 'johnd');
  final passwordCtrl = TextEditingController(text: 'm38rmF\$');

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  String? validateUsername(String? v) {
    if (v == null || v.isEmpty) return 'Username is required';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final result = await ApiServices.post<LoginModel>(
        LoginModel.fromJson,
        AppEndpoint.loginURL,
        body: {
          'username': usernameCtrl.text.trim(),
          'password': passwordCtrl.text.trim(),
        },
        isBasic: true,
        showResult: true,
        statusCode: 201,
      );

      if (result != null && result.token != null) {
        await LocalStorage.saveToken(token: result.token!);
        await LocalStorage.saveName(name: usernameCtrl.text.trim());
        await LocalStorage.setLoggedIn(value: true);

        AppSnackBar.success('Login Successful!');
        Get.offAllNamed(Routes.darazListing);
      }
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
