import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/diabetes_record_model.dart';

class DiabetesReportController extends GetxController {
  final Box<DiabetesRecord> recordBox = Hive.box<DiabetesRecord>('diabetes_records');

  var records = <DiabetesRecord>[].obs;

  static const List<String> readingTypes = ['Fasting', 'Random', 'Post Prandial (PP)'];
  static const List<String> units = ['mg/dL', 'mmol/L'];

  @override
  void onInit() {
    super.onInit();
    loadRecords();
  }

  void loadRecords() {
    final list = recordBox.values.toList();
    list.sort((a, b) => (b.recordDate ?? DateTime(2000)).compareTo(a.recordDate ?? DateTime(2000)));
    records.assignAll(list);
  }

  Future<void> addRecord({
    required double value,
    required String unit,
    required String readingType,
    required DateTime recordDate,
    String? notes,
    String? editId,
  }) async {
    final id = editId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final record = DiabetesRecord(
      id: id,
      value: value,
      unit: unit,
      readingType: readingType,
      recordDate: recordDate,
      notes: notes,
    );
    await recordBox.put(id, record);
    loadRecords();
  }

  Future<void> deleteRecord(String id) async {
    await recordBox.delete(id);
    records.removeWhere((r) => r.id == id);
  }

  /// Simple threshold-based flag for the card UI. Uses standard fasting/random
  /// mg/dL reference ranges; mmol/L values are converted for comparison.
  bool isHigh(DiabetesRecord r) {
    final val = r.unit == 'mmol/L' ? (r.value ?? 0) * 18.0 : (r.value ?? 0);
    if (r.readingType == 'Fasting') return val > 125;
    return val > 180; // Random / PP
  }
}
