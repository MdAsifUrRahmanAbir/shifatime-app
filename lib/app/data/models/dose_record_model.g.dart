// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoseRecordAdapter extends TypeAdapter<DoseRecord> {
  @override
  final int typeId = 1;

  @override
  DoseRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoseRecord(
      id: fields[0] as String?,
      medicineId: fields[1] as String?,
      medicineName: fields[2] as String?,
      timeStr: fields[3] as String?,
      dateStr: fields[4] as String?,
      status: fields[5] as String?,
      takenTime: fields[6] as DateTime?,
      snoozeUntil: fields[7] as DateTime?,
      customDosage: fields[8] as String?,
      medicineType: fields[9] as String?,
      mealRelation: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoseRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicineId)
      ..writeByte(2)
      ..write(obj.medicineName)
      ..writeByte(3)
      ..write(obj.timeStr)
      ..writeByte(4)
      ..write(obj.dateStr)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.takenTime)
      ..writeByte(7)
      ..write(obj.snoozeUntil)
      ..writeByte(8)
      ..write(obj.customDosage)
      ..writeByte(9)
      ..write(obj.medicineType)
      ..writeByte(10)
      ..write(obj.mealRelation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
