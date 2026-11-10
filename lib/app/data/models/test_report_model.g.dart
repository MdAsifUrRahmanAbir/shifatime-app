// GENERATED CODE - DO NOT MODIFY BY HAND

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
      category: fields[7] as String?,
      labName: fields[8] as String?,
      doctorName: fields[9] as String?,
      parameters: (fields[10] as List?)?.cast<TestParameter>(),
    );
  }

  @override
  void write(BinaryWriter writer, TestReport obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.labName)
      ..writeByte(9)
      ..write(obj.doctorName)
      ..writeByte(10)
      ..write(obj.parameters);
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
