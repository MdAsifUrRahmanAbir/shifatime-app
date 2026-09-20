import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/pressure_record_model.dart';

class PressureReportController extends GetxController {
  final Box<PressureRecord> recordBox = Hive.box<PressureRecord>('pressure_records');

  var records = <PressureRecord>[].obs;

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
    required int systolic,
    required int diastolic,
    required DateTime recordDate,
    String? notes,
    String? editId,
  }) async {
    final id = editId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final record = PressureRecord(
      id: id,
      systolic: systolic,
      diastolic: diastolic,
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

  /// Standard blood pressure category, per AHA guidelines.
  String category(PressureRecord r) {
    final sys = r.systolic ?? 0;
    final dia = r.diastolic ?? 0;
    if (sys >= 180 || dia >= 120) return 'Hypertensive Crisis';
    if (sys >= 140 || dia >= 90) return 'Hypertension Stage 2';
    if (sys >= 130 || dia >= 80) return 'Hypertension Stage 1';
    if (sys >= 120 && dia < 80) return 'Elevated';
    return 'Normal';
  }

  bool isHigh(PressureRecord r) => category(r) != 'Normal' && category(r) != 'Elevated';
}
