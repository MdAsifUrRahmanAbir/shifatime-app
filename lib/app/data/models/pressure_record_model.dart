import 'package:hive/hive.dart';

part 'pressure_record_model.g.dart';

@HiveType(typeId: 4)
class PressureRecord extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  int? systolic;

  @HiveField(2)
  int? diastolic;

  @HiveField(3)
  DateTime? recordDate;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  int? pulse; // heart rate, bpm (optional)

  @HiveField(6)
  String? arm; // 'Left' / 'Right' (optional)

  PressureRecord({
    this.id,
    this.systolic,
    this.diastolic,
    this.recordDate,
    this.notes,
    this.pulse,
    this.arm,
  });
}
