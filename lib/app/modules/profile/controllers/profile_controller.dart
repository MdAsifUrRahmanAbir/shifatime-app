import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/app_endpoint.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';
import '../model/user_model.dart';

class ProfileController extends GetxController {
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      final result = await ApiServices.get<UserModel>(
        UserModel.fromJson,
        AppEndpoint.profileGetURL,
        showResult: true,
      );
      if (result != null) {
        user.value = result;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      await LocalStorage.signOut();
      Get.offAllNamed(Routes.login);
    } finally {
      isLoggingOut.value = false;
    }
  }
}
