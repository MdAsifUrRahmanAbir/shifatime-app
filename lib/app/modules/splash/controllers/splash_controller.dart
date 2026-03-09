import 'dart:async';
import 'package:get/get.dart';

import '../../../core/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(const Duration(seconds: 2), () {
      _goToScreen();
    });
  }

  void _goToScreen() {
    if (LocalStorage.isLoggedIn()) {
      Get.offAllNamed(Routes.darazListing);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }
}
