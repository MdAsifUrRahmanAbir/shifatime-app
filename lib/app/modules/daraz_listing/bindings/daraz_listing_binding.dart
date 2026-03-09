import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';

class DarazListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DarazListingController>(() => DarazListingController());
  }
}
