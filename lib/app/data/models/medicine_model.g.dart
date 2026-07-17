// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      id: fields[0] as String?,
      name: fields[1] as String?,
      type: fields[2] as String?,
      dosage: fields[3] as int?,
      reminderTimes: (fields[4] as List?)?.cast<String>(),
      mealRelation: fields[5] as String?,
      isActive: fields[6] as bool?,
      durationType: fields[7] as String?,
      durationValue: fields[8] as String?,
      durationUnit: fields[9] as String?,
      totalStock: fields[10] as int?,
      stockThreshold: fields[11] as int?,
      isStockAlertEnabled: fields[12] as bool?,
      customDosage: fields[13] as String?,
      applicationArea: fields[14] as String?,
      usageInstruction: fields[15] as String?,
      startDate: fields[16] as DateTime?,
      snoozeCount: fields[17] as int?,
      snoozeUntil: fields[18] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.dosage)
      ..writeByte(4)
      ..write(obj.reminderTimes)
      ..writeByte(5)
      ..write(obj.mealRelation)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.durationType)
      ..writeByte(8)
      ..write(obj.durationValue)
      ..writeByte(9)
      ..write(obj.durationUnit)
      ..writeByte(10)
      ..write(obj.totalStock)
      ..writeByte(11)
      ..write(obj.stockThreshold)
      ..writeByte(12)
      ..write(obj.isStockAlertEnabled)
      ..writeByte(13)
      ..write(obj.customDosage)
      ..writeByte(14)
      ..write(obj.applicationArea)
      ..writeByte(15)
      ..write(obj.usageInstruction)
      ..writeByte(16)
      ..write(obj.startDate)
      ..writeByte(17)
      ..write(obj.snoozeCount)
      ..writeByte(18)
      ..write(obj.snoozeUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
