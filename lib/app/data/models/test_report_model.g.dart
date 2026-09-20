// GENERATED CODE - DO NOT MODIFY BY HAND
// (Hand-authored to match hive_generator's output style — regenerate with
//  `dart run build_runner build --delete-conflicting-outputs` once merged.)

part of 'test_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestReportAdapter extends TypeAdapter<TestReport> {
  @override
  final int typeId = 2;

  @override
  TestReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TestReport(
      id: fields[0] as String?,
      testName: fields[1] as String?,
      resultValue: fields[2] as String?,
      unit: fields[3] as String?,
      normalRange: fields[4] as String?,
      testDate: fields[5] as DateTime?,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TestReport obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.testName)
      ..writeByte(2)
      ..write(obj.resultValue)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.normalRange)
      ..writeByte(5)
      ..write(obj.testDate)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
