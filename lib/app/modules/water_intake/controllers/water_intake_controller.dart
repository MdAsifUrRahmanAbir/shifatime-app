import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/notification_service.dart';

class WaterIntakeController extends GetxController {
  final targetMl = 2000.0.obs;
  final consumedMl = 0.0.obs;
  final logs = <Map<String, dynamic>>[].obs;

  late final String dateKey;
  final formattedDate = ''.obs;
  final formattedDay = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDate();
    loadDailyData();
  }

  void _initializeDate() {
    final now = DateTime.now();
    dateKey = DateFormat('yyyy_MM_dd').format(now);
    formattedDate.value = DateFormat('dd MMMM, yyyy').format(now);
    formattedDay.value = DateFormat('EEEE').format(now);
  }

  void loadDailyData() {
    targetMl.value = LocalStorage.getWaterTarget();
    final todayLogs = LocalStorage.getWaterLogs(dateKey);
    logs.assignAll(todayLogs);
    _calculateTotal();
  }

  void logWater(int amount) {
    final timeStr = DateFormat('hh:mm a').format(DateTime.now());
    final newLog = {
      'time': timeStr,
      'amount': amount,
    };
    logs.insert(0, newLog); // Put new logs at the top
    _saveLogs();

    // Log to activity history logs
    final now = DateTime.now();
    final logBox = Hive.box('activity_logs');
    logBox.add({
      'id': 'water_${now.toIso8601String()}',
      'type': 'water',
      'name': 'Water Intake',
      'action': 'water_logged',
      'timestamp': now.toIso8601String(),
      'details': '+$amount ml',
    });
  }

  void deleteLog(int index) {
    if (index >= 0 && index < logs.length) {
      final removed = logs[index];
      logs.removeAt(index);
      _saveLogs();

      // Log deletion
      final now = DateTime.now();
      final logBox = Hive.box('activity_logs');
      logBox.add({
        'id': 'water_del_${now.toIso8601String()}',
        'type': 'water',
        'name': 'Water Intake Deleted',
        'action': 'dismissed',
        'timestamp': now.toIso8601String(),
        'details': '-${removed["amount"]} ml',
      });
    }
  }

  Future<void> _saveLogs() async {
    LocalStorage.saveWaterLogs(dateKey, logs);
    _calculateTotal();
    await NotificationService.rescheduleWaterReminders(consumedMl.value, targetMl.value);
  }

  void _calculateTotal() {
    double total = 0.0;
    for (final log in logs) {
      total += (log['amount'] as num?)?.toDouble() ?? 0.0;
    }
    consumedMl.value = total;
  }

  Future<void> updateTarget(double target) async {
    if (target > 0) {
      targetMl.value = target;
      LocalStorage.saveProfile(
        name: LocalStorage.getName(),
        age: LocalStorage.getAge(),
        height: LocalStorage.getHeight(),
        weight: LocalStorage.getWeight(),
        waterTarget: target,
        gender: LocalStorage.getGender(),
      );
      loadDailyData();
      await NotificationService.rescheduleWaterReminders(consumedMl.value, targetMl.value);
    }
  }
}
