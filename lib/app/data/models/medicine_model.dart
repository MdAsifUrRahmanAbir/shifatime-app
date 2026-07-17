import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 0)
class Medicine extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? type; // Tablet, Syrup, Injection, Capsule

  @HiveField(3)
  int? dosage;

  @HiveField(4)
  List<String>? reminderTimes; // e.g., ["08:00", "14:00", "22:00"]

  @HiveField(5)
  String? mealRelation; // Before Meal, After Meal, Empty Stomach

  @HiveField(6)
  bool? isActive;

  @HiveField(7)
  String? durationType; // Nonstop, Specified, Specific Days

  @HiveField(8)
  String? durationValue; // "5", "Mon,Tue,Wed", etc.

  @HiveField(9)
  String? durationUnit; // Days, Weeks, Months

  @HiveField(10)
  int? totalStock;

  @HiveField(11)
  int? stockThreshold;

  @HiveField(12)
  bool? isStockAlertEnabled;

  @HiveField(13)
  String? customDosage;

  @HiveField(14)
  String? applicationArea;

  @HiveField(15)
  String? usageInstruction;

  @HiveField(16)
  DateTime? startDate;

  @HiveField(17)
  int? snoozeCount;

  @HiveField(18)
  DateTime? snoozeUntil;

  Medicine({
    this.id,
    this.name,
    this.type,
    this.dosage,
    this.reminderTimes,
    this.mealRelation,
    this.isActive = true,
    this.durationType = 'Nonstop',
    this.durationValue,
    this.durationUnit,
    this.totalStock,
    this.stockThreshold = 5,
    this.isStockAlertEnabled = true,
    this.customDosage,
    this.applicationArea,
    this.usageInstruction,
    this.startDate,
    this.snoozeCount = 0,
    this.snoozeUntil,
  });
}
