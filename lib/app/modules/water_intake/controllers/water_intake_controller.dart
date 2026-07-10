import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/local_storage_service.dart';

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
  }

  void deleteLog(int index) {
    if (index >= 0 && index < logs.length) {
      logs.removeAt(index);
      _saveLogs();
    }
  }

  void _saveLogs() {
    LocalStorage.saveWaterLogs(dateKey, logs);
    _calculateTotal();
  }

  void _calculateTotal() {
    double total = 0.0;
    for (final log in logs) {
      total += (log['amount'] as num?)?.toDouble() ?? 0.0;
    }
    consumedMl.value = total;
  }

  void updateTarget(double target) {
    if (target > 0) {
      targetMl.value = target;
      LocalStorage.saveProfile(
        name: LocalStorage.getName(),
        age: LocalStorage.getAge(),
        height: LocalStorage.getHeight(),
        weight: LocalStorage.getWeight(),
        waterTarget: target,
      );
      loadDailyData();
    }
  }
}
