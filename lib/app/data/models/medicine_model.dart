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
  });
}
