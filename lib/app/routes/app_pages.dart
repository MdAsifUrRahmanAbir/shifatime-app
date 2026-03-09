import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/daraz_listing/bindings/daraz_listing_binding.dart';
import '../modules/daraz_listing/views/daraz_listing_view.dart';

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
      name: Routes.darazListing,
      page: () => const DarazListingView(),
      binding: DarazListingBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
