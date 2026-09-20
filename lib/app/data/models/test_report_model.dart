import 'package:hive/hive.dart';

part 'test_report_model.g.dart';

@HiveType(typeId: 2)
class TestReport extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? testName; // e.g. 'CBC', 'Lipid Profile', 'Creatinine' — free text

  @HiveField(2)
  String? resultValue; // kept as String — results can be numeric or descriptive

  @HiveField(3)
  String? unit; // e.g. 'mg/dL', 'g/dL' — optional

  @HiveField(4)
  String? normalRange; // e.g. '4.5 - 11.0' — optional

  @HiveField(5)
  DateTime? testDate;

  @HiveField(6)
  String? notes;

  TestReport({
    this.id,
    this.testName,
    this.resultValue,
    this.unit,
    this.normalRange,
    this.testDate,
    this.notes,
  });
}
