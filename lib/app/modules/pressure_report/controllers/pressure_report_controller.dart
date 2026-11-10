import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../core/services/health_analytics.dart';
import '../../../data/models/pressure_record_model.dart';

class PressureReportController extends GetxController {
  final Box<PressureRecord> recordBox = Hive.box<PressureRecord>('pressure_records');

  final RxList<PressureRecord> records = <PressureRecord>[].obs;
  final Rxn<int> periodDays = Rxn<int>(30);

  static const List<int?> periods = [7, 30, 90, null];
  static const List<String> arms = ['Left', 'Right'];

  @override
  void onInit() {
    super.onInit();
    loadRecords();
  }

  void loadRecords() {
    final list = recordBox.values.toList()
      ..sort((a, b) => (b.recordDate ?? DateTime(2000)).compareTo(a.recordDate ?? DateTime(2000)));
    records.assignAll(list);
  }

  List<PressureRecord> get filtered {
    final start = HealthAnalytics.periodStart(periodDays.value);
    if (start == null) return records;
    return records.where((r) => !(r.recordDate ?? DateTime(2000)).isBefore(start)).toList();
  }

  HealthStatus status(PressureRecord r) => HealthAnalytics.bpStatus(r.systolic ?? 0, r.diastolic ?? 0);

  double? get avgSystolic => HealthAnalytics.average(filtered.map((r) => r.systolic ?? 0));
  double? get avgDiastolic => HealthAnalytics.average(filtered.map((r) => r.diastolic ?? 0));
  double? get avgPulse => HealthAnalytics.average(filtered.where((r) => r.pulse != null).map((r) => r.pulse!));

  HealthStatus? get averageStatus {
    final s = avgSystolic, d = avgDiastolic;
    if (s == null || d == null) return null;
    return HealthAnalytics.bpStatus(s.round(), d.round());
  }

  int get highCount => filtered.where((r) {
        final l = status(r).level;
        return l == HealthLevel.high || l == HealthLevel.critical;
      }).length;

  PressureRecord? get highest => filtered.isEmpty
      ? null
      : filtered.reduce((a, b) => (a.systolic ?? 0) >= (b.systolic ?? 0) ? a : b);

  PressureRecord? get lowest => filtered.isEmpty
      ? null
      : filtered.reduce((a, b) => (a.systolic ?? 0) <= (b.systolic ?? 0) ? a : b);

  Future<void> saveRecord({
    String? editId,
    required int systolic,
    required int diastolic,
    int? pulse,
    String? arm,
    required DateTime recordDate,
    String? notes,
  }) async {
    final id = editId ?? DateTime.now().millisecondsSinceEpoch.toString();
    await recordBox.put(
      id,
      PressureRecord(
        id: id,
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
        arm: arm,
        recordDate: recordDate,
        notes: notes,
      ),
    );
    loadRecords();
  }

  Future<void> deleteRecord(String id) async {
    await recordBox.delete(id);
    records.removeWhere((r) => r.id == id);
  }

  static String periodLabel(int? d) => d == null ? 'All' : '$d days';
}
