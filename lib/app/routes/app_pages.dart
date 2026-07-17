import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/medicine/bindings/medicine_binding.dart';
import '../modules/medicine/views/medicine_view.dart';
import '../modules/medicine/views/add_medicine_view.dart';
import '../modules/medicine/views/medicine_details_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/profile_setup_view.dart';
import '../modules/water_intake/bindings/water_intake_binding.dart';
import '../modules/water_intake/views/water_intake_view.dart';
import '../modules/health_tips/views/health_tips_view.dart';
import '../modules/menu/views/menu_view.dart';
import '../modules/medicine/views/full_screen_alarm_view.dart';
import '../modules/menu/views/notification_settings_view.dart';
import '../modules/menu/views/reminder_history_view.dart';

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
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profileSetup,
      page: () => const ProfileSetupView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.waterIntake,
      page: () => const WaterIntakeView(),
      binding: WaterIntakeBinding(),
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
    GetPage(
      name: Routes.healthTips,
      page: () => const HealthTipsView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.menu,
      page: () => const MenuView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.notificationSettings,
      page: () => const NotificationSettingsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.reminderHistory,
      page: () => const ReminderHistoryView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.fullScreenAlarm,
      page: () => const FullScreenAlarmView(),
      binding: MedicineBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
