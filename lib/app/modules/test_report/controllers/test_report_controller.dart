import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/test_report_model.dart';

class TestReportController extends GetxController {
  final Box<TestReport> reportBox = Hive.box<TestReport>('test_reports');

  var reports = <TestReport>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  void loadReports() {
    final list = reportBox.values.toList();
    // Newest first
    list.sort((a, b) => (b.testDate ?? DateTime(2000)).compareTo(a.testDate ?? DateTime(2000)));
    reports.assignAll(list);
  }

  Future<void> addReport({
    required String testName,
    required String resultValue,
    String? unit,
    String? normalRange,
    required DateTime testDate,
    String? notes,
    String? editId,
  }) async {
    final id = editId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final report = TestReport(
      id: id,
      testName: testName,
      resultValue: resultValue,
      unit: unit,
      normalRange: normalRange,
      testDate: testDate,
      notes: notes,
    );
    await reportBox.put(id, report);
    loadReports();
  }

  Future<void> deleteReport(String id) async {
    await reportBox.delete(id);
    reports.removeWhere((r) => r.id == id);
  }

  /// Grouped by month label, e.g. "September 2026" -> [reports...], for a
  /// history timeline view. Preserves the newest-first ordering.
  Map<String, List<TestReport>> get groupedByMonth {
    final Map<String, List<TestReport>> grouped = {};
    for (final r in reports) {
      final date = r.testDate ?? DateTime.now();
      final key = '${_monthName(date.month)} ${date.year}';
      grouped.putIfAbsent(key, () => []).add(r);
    }
    return grouped;
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }
}
