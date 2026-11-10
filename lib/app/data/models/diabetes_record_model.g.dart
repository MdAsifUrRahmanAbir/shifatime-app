// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diabetes_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiabetesRecordAdapter extends TypeAdapter<DiabetesRecord> {
  @override
  final int typeId = 3;

  @override
  DiabetesRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiabetesRecord(
      id: fields[0] as String?,
      value: fields[1] as double?,
      unit: fields[2] as String?,
      readingType: fields[3] as String?,
      recordDate: fields[4] as DateTime?,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DiabetesRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.readingType)
      ..writeByte(4)
      ..write(obj.recordDate)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiabetesRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
