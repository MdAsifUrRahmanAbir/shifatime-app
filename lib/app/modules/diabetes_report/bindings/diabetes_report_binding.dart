import 'package:get/get.dart';
import '../controllers/diabetes_report_controller.dart';

class DiabetesReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiabetesReportController>(() => DiabetesReportController());
  }
}
