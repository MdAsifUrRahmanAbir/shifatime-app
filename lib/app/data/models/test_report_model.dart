import 'package:hive/hive.dart';

import 'test_parameter_model.dart';

part 'test_report_model.g.dart';

/// A lab report: one test panel (e.g. CBC) done on one date, with its results.
///
/// Reports saved before v3.1 have a single result in [resultValue] / [unit] /
/// [normalRange] and no [parameters]; [allParameters] handles both shapes.
@HiveType(typeId: 2)
class TestReport extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? testName; // Panel / test title shown to the user, e.g. 'Lipid Profile'

  @HiveField(2)
  String? resultValue; // legacy single-result field

  @HiveField(3)
  String? unit; // legacy single-result field

  @HiveField(4)
  String? normalRange; // legacy single-result field

  @HiveField(5)
  DateTime? testDate;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  String? category; // catalog panel name, or 'Custom'

  @HiveField(8)
  String? labName;

  @HiveField(9)
  String? doctorName; // referred by

  @HiveField(10)
  List<TestParameter>? parameters;

  TestReport({
    this.id,
    this.testName,
    this.resultValue,
    this.unit,
    this.normalRange,
    this.testDate,
    this.notes,
    this.category,
    this.labName,
    this.doctorName,
    this.parameters,
  });

  /// Results of this report, including legacy single-value reports.
  List<TestParameter> get allParameters {
    final list = parameters;
    if (list != null && list.isNotEmpty) return list;
    if (resultValue == null || resultValue!.isEmpty) return const [];
    return [
      TestParameter(name: testName, value: resultValue, unit: unit, refRange: normalRange),
    ];
  }
}
