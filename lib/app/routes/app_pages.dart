import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/medicine/bindings/medicine_binding.dart';
import '../modules/medicine/views/medicine_view.dart';
import '../modules/medicine/views/add_medicine_view.dart';
import '../modules/medicine/views/medicine_details_view.dart';

part 'app_routes.dart';

/// GetX route configuration — all pages registered here.
class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.medicine,
      page: () => const MedicineView(),
      binding: MedicineBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.addMedicine,
      page: () => const AddMedicineView(),
      binding: MedicineBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.medicineDetails,
      page: () => const MedicineDetailsView(),
      binding: MedicineBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
