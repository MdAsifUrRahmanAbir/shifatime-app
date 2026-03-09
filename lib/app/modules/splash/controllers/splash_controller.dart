import 'dart:async';
import 'package:get/get.dart';
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
    Get.offAllNamed(Routes.medicine);
  }
}
