// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pressure_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PressureRecordAdapter extends TypeAdapter<PressureRecord> {
  @override
  final int typeId = 4;

  @override
  PressureRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PressureRecord(
      id: fields[0] as String?,
      systolic: fields[1] as int?,
      diastolic: fields[2] as int?,
      recordDate: fields[3] as DateTime?,
      notes: fields[4] as String?,
      pulse: fields[5] as int?,
      arm: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PressureRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.systolic)
      ..writeByte(2)
      ..write(obj.diastolic)
      ..writeByte(3)
      ..write(obj.recordDate)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.pulse)
      ..writeByte(6)
      ..write(obj.arm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PressureRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
