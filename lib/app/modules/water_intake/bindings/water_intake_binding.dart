import 'package:get/get.dart';
import '../controllers/water_intake_controller.dart';

class WaterIntakeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaterIntakeController>(() => WaterIntakeController());
  }
}
