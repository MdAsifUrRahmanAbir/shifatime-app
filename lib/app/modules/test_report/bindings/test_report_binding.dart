import 'package:get/get.dart';
import '../controllers/test_report_controller.dart';

class TestReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestReportController>(() => TestReportController());
  }
}
