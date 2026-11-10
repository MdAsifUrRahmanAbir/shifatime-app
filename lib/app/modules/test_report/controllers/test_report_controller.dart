import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../core/services/health_analytics.dart';
import '../../../data/lab_test_catalog.dart';
import '../../../data/models/test_parameter_model.dart';
import '../../../data/models/test_report_model.dart';

/// A previous result of the same parameter, for trend comparison.
class PreviousResult {
  final TestParameter param;
  final DateTime date;
  const PreviousResult(this.param, this.date);
}

class TestReportController extends GetxController {
  final Box<TestReport> reportBox = Hive.box<TestReport>('test_reports');

  final RxList<TestReport> reports = <TestReport>[].obs;
  final RxString categoryFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  void loadReports() {
    final list = reportBox.values.toList()
      ..sort((a, b) => (b.testDate ?? DateTime(2000)).compareTo(a.testDate ?? DateTime(2000)));
    reports.assignAll(list);
  }

  TestReport? byId(String? id) => reports.firstWhereOrNull((r) => r.id == id);

  /// Categories that have at least one report, in catalog order.
  List<String> get categories {
    final used = reports.map((r) => r.category ?? LabTestCatalog.custom).toSet();
    return [
      'All',
      ...LabTestCatalog.panels.map((p) => p.name).where(used.contains),
      if (used.contains(LabTestCatalog.custom)) LabTestCatalog.custom,
    ];
  }

  List<TestReport> get filtered => categoryFilter.value == 'All'
      ? reports
      : reports.where((r) => (r.category ?? LabTestCatalog.custom) == categoryFilter.value).toList();

  Map<String, List<TestReport>> get groupedByMonth {
    final grouped = <String, List<TestReport>>{};
    for (final r in filtered) {
      final key = DateFormat('MMMM yyyy').format(r.testDate ?? DateTime.now());
      grouped.putIfAbsent(key, () => []).add(r);
    }
    return grouped;
  }

  static List<(TestParameter, HealthStatus)> flagged(TestReport r) => r.allParameters
      .map((p) => (p, HealthAnalytics.labFlag(p.value, p.refRange)))
      .where((e) => e.$2.isAbnormal)
      .toList();

  /// Abnormal results across the latest report of each panel.
  int get abnormalInLatest {
    final seen = <String>{};
    int count = 0;
    for (final r in reports) {
      final key = r.category ?? r.testName ?? '';
      if (!seen.add(key)) continue;
      count += flagged(r).length;
    }
    return count;
  }

  /// The most recent earlier result for a parameter with the same name.
  PreviousResult? previousResult(String? paramName, TestReport current) {
    if (paramName == null) return null;
    final date = current.testDate ?? DateTime.now();
    for (final r in reports) {
      // reports are newest first, so the first older match is the latest previous
      if (r.id == current.id) continue;
      final d = r.testDate ?? DateTime(2000);
      if (!d.isBefore(date)) continue;
      for (final p in r.allParameters) {
        if ((p.name ?? '').toLowerCase() == paramName.toLowerCase() &&
            (p.value ?? '').isNotEmpty) {
          return PreviousResult(p, d);
        }
      }
    }
    return null;
  }

  Future<void> saveReport({
    String? editId,
    required String title,
    required String category,
    required DateTime testDate,
    required List<TestParameter> parameters,
    String? labName,
    String? doctorName,
    String? notes,
  }) async {
    final id = editId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final report = TestReport(
      id: id,
      testName: title,
      category: category,
      testDate: testDate,
      parameters: parameters,
      labName: labName,
      doctorName: doctorName,
      notes: notes,
    );
    await reportBox.put(id, report);
    loadReports();
  }

  Future<void> deleteReport(String id) async {
    await reportBox.delete(id);
    reports.removeWhere((r) => r.id == id);
  }
}
