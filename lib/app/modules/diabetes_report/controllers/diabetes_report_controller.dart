import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../core/services/health_analytics.dart';
import '../../../data/models/diabetes_record_model.dart';

class DiabetesReportController extends GetxController {
  final Box<DiabetesRecord> recordBox = Hive.box<DiabetesRecord>('diabetes_records');

  final RxList<DiabetesRecord> records = <DiabetesRecord>[].obs;

  /// Days shown in stats/chart; null = all time.
  final Rxn<int> periodDays = Rxn<int>(30);
  final RxString typeFilter = 'All'.obs;

  static const List<String> readingTypes = [
    'Fasting',
    'Before Meal',
    'Post Prandial (PP)',
    'Random',
    'Bedtime',
  ];
  static const List<String> units = ['mg/dL', 'mmol/L'];
  static const List<int?> periods = [7, 30, 90, null];

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

  /// Records in the selected period and type, newest first.
  List<DiabetesRecord> get filtered {
    final start = HealthAnalytics.periodStart(periodDays.value);
    return records.where((r) {
      if (start != null && (r.recordDate ?? DateTime(2000)).isBefore(start)) return false;
      if (typeFilter.value != 'All' && r.readingType != typeFilter.value) return false;
      return true;
    }).toList();
  }

  double mgdl(DiabetesRecord r) => HealthAnalytics.toMgdl(r.value ?? 0, r.unit);

  HealthStatus status(DiabetesRecord r) =>
      HealthAnalytics.sugarStatus(r.value ?? 0, r.unit, r.readingType);

  double? get averageMgdl => HealthAnalytics.average(filtered.map(mgdl));

  /// Estimated HbA1c from all readings in the last 90 days (needs >= 5).
  double? get estimatedHbA1c {
    final start = HealthAnalytics.periodStart(90)!;
    final recent = records.where((r) => !(r.recordDate ?? DateTime(2000)).isBefore(start)).map(mgdl).toList();
    if (recent.length < 5) return null;
    return HealthAnalytics.estimatedHbA1c(HealthAnalytics.average(recent)!);
  }

  int get highCount => filtered.where((r) => mgdl(r) >= 70 && status(r).isAbnormal).length;

  int get lowCount => filtered.where((r) => mgdl(r) < 70).length;

  int? get inRangePercent {
    final f = filtered;
    if (f.isEmpty) return null;
    return (f.where((r) => status(r).level == HealthLevel.normal).length * 100 / f.length).round();
  }

  Future<void> saveRecord({
    String? editId,
    required double value,
    required String unit,
    required String readingType,
    required DateTime recordDate,
    String? notes,
  }) async {
    final id = editId ?? DateTime.now().millisecondsSinceEpoch.toString();
    await recordBox.put(
      id,
      DiabetesRecord(
        id: id,
        value: value,
        unit: unit,
        readingType: readingType,
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

  /// User-facing name for a stored reading type.
  static String displayType(String? t) => HealthAnalytics.sugarTypeLabel(t);
}
