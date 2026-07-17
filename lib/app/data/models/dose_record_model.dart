import 'package:hive/hive.dart';

part 'dose_record_model.g.dart';

@HiveType(typeId: 1)
class DoseRecord extends HiveObject {
  @HiveField(0)
  String? id; // unique key: medicineId_date_timeIndex

  @HiveField(1)
  String? medicineId;

  @HiveField(2)
  String? medicineName;

  @HiveField(3)
  String? timeStr; // e.g. '08:00' or '22:00'

  @HiveField(4)
  String? dateStr; // e.g. '2026_07_14'

  @HiveField(5)
  String? status; // 'pending', 'taken', 'skipped', 'missed', 'snoozed'

  @HiveField(6)
  DateTime? takenTime;

  @HiveField(7)
  DateTime? snoozeUntil;

  @HiveField(8)
  String? customDosage;

  @HiveField(9)
  String? medicineType;

  @HiveField(10)
  String? mealRelation;

  DoseRecord({
    this.id,
    this.medicineId,
    this.medicineName,
    this.timeStr,
    this.dateStr,
    this.status = 'pending',
    this.takenTime,
    this.snoozeUntil,
    this.customDosage,
    this.medicineType,
    this.mealRelation,
  });
}
