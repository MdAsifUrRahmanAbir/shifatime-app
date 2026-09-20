import 'package:hive/hive.dart';

part 'diabetes_record_model.g.dart';

@HiveType(typeId: 3)
class DiabetesRecord extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  double? value; // blood sugar reading

  @HiveField(2)
  String? unit; // 'mg/dL' or 'mmol/L'

  @HiveField(3)
  String? readingType; // 'Fasting', 'Random', 'Post Prandial (PP)'

  @HiveField(4)
  DateTime? recordDate;

  @HiveField(5)
  String? notes;

  DiabetesRecord({
    this.id,
    this.value,
    this.unit = 'mg/dL',
    this.readingType = 'Fasting',
    this.recordDate,
    this.notes,
  });
}
