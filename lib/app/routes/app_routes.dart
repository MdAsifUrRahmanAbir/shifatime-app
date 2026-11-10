part of 'app_pages.dart';

/// All named routes for the app — update here and it applies everywhere.
abstract class Routes {
  Routes._();

  static const splash = '/splash';
  static const profile = '/profile';
  static const profileSetup = '/profile_setup';
  static const waterIntake = '/water_intake';
  static const medicine = '/medicine';
  static const addMedicine = '/add_medicine';
  static const medicineDetails = '/medicine_details';
  static const healthTips = '/health_tips';
  static const menu = '/menu';
  static const inventory = '/inventory';
  static const achievements = '/achievements';
  static const notificationSettings = '/notification_settings';
  static const reminderHistory = '/reminder_history';
  static const notifications = '/notifications';
  static const fullScreenAlarm = '/full_screen_alarm';

  // ── Health Reports (new) ──────────────────────────────────────────────────
  static const testReport = '/test_report';
  static const addTestReport = '/add_test_report';
  static const diabetesReport = '/diabetes_report';
  static const addDiabetesRecord = '/add_diabetes_record';
  static const pressureReport = '/pressure_report';
  static const addPressureRecord = '/add_pressure_record';
  static const testReportDetail = '/test_report_detail';
  static const healthSummary = '/health_summary';
}
