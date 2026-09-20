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
import '../modules/inventory/views/inventory_view.dart';
import '../modules/achievements/views/achievements_view.dart';

// ── Health Reports (new) ────────────────────────────────────────────────────
import '../modules/test_report/bindings/test_report_binding.dart';
import '../modules/test_report/views/test_report_view.dart';
import '../modules/test_report/views/add_test_report_view.dart';
import '../modules/diabetes_report/bindings/diabetes_report_binding.dart';
import '../modules/diabetes_report/views/diabetes_report_view.dart';
import '../modules/diabetes_report/views/add_diabetes_record_view.dart';
import '../modules/pressure_report/bindings/pressure_report_binding.dart';
import '../modules/pressure_report/views/pressure_report_view.dart';
import '../modules/pressure_report/views/add_pressure_record_view.dart';

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
      name: Routes.inventory,
      page: () => const InventoryView(),
      binding: MedicineBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.achievements,
      page: () => const AchievementsView(),
      transition: Transition.rightToLeft,
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

    // ── Health Reports (new) ────────────────────────────────────────────────
    GetPage(
      name: Routes.testReport,
      page: () => const TestReportView(),
      binding: TestReportBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.addTestReport,
      page: () => const AddTestReportView(),
      binding: TestReportBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.diabetesReport,
      page: () => const DiabetesReportView(),
      binding: DiabetesReportBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.addDiabetesRecord,
      page: () => const AddDiabetesRecordView(),
      binding: DiabetesReportBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.pressureReport,
      page: () => const PressureReportView(),
      binding: PressureReportBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.addPressureRecord,
      page: () => const AddPressureRecordView(),
      binding: PressureReportBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
