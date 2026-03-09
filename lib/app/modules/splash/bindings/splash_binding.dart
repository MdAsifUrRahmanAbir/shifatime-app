import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

/// Remitium pattern: Get.put (eager) — NOT lazyPut.
/// This ensures SplashController is created immediately when
/// the splash route is opened, so onReady() fires correctly.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}
