import 'package:get/get.dart';
import '../controllers/pressure_report_controller.dart';

class PressureReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PressureReportController>(() => PressureReportController());
  }
}
