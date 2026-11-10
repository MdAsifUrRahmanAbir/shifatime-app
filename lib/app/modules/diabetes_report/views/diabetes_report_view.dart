import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/health_analytics.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/health_widgets.dart';
import '../../../widgets/trend_line_chart.dart';
import '../controllers/diabetes_report_controller.dart';
import '../widgets/diabetes_record_card.dart';

class DiabetesReportView extends GetView<DiabetesReportController> {
  const DiabetesReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Blood Sugar', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(Icons.picture_as_pdf_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
                tooltip: 'Export PDF',
                onPressed: controller.filtered.isEmpty
                    ? null
                    : () => PdfExportService.shareDiabetesRecords(controller.filtered),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.addDiabetesRecord),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Reading', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ResponsiveLayout(
        mobile: Obx(() {
          if (controller.records.isEmpty) {
            return const Center(
              child: HealthEmptyState(
                icon: Icons.water_drop_outlined,
                title: 'No blood sugar readings yet',
                subtitle: 'Log fasting and after-meal readings to see\nyour averages, trend and estimated HbA1c.',
              ),
            );
          }
          final list = controller.filtered;
          final latest = controller.records.first;
          final latestStatus = controller.status(latest);
          final avg = controller.averageMgdl;
          final a1c = controller.estimatedHbA1c;
          final inRange = controller.inRangePercent;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            physics: const BouncingScrollPhysics(),
            children: [
              // Latest reading
              HealthCard(
                borderColor: latestStatus.color.withValues(alpha: 0.35),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latest • ${DiabetesReportController.displayType(latest.readingType)}',
                              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '${latest.unit == 'mmol/L' ? latest.value?.toStringAsFixed(1) : latest.value?.toStringAsFixed(0)} ${latest.unit}',
                            style: GoogleFonts.outfit(
                                fontSize: 28, fontWeight: FontWeight.bold, color: latestStatus.color),
                          ),
                        ],
                      ),
                    ),
                    StatusPill(latestStatus, fontSize: 12),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ChoiceChipsRow<int?>(
                values: DiabetesReportController.periods,
                selected: controller.periodDays.value,
                labelOf: DiabetesReportController.periodLabel,
                onSelected: (v) => controller.periodDays.value = v,
              ),
              const SizedBox(height: 12),
              HealthCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            label: 'Average',
                            value: avg == null ? '-' : avg.toStringAsFixed(0),
                            caption: 'mg/dL • ${list.length} reading${list.length == 1 ? '' : 's'}',
                          ),
                        ),
                        Expanded(
                          child: StatTile(
                            label: 'In target',
                            value: inRange == null ? '-' : '$inRange%',
                            caption: '${controller.highCount} high • ${controller.lowCount} low',
                            valueColor: inRange == null
                                ? null
                                : (inRange >= 70 ? AppColors.primary : AppColors.warning),
                          ),
                        ),
                        Expanded(
                          child: StatTile(
                            label: 'Est. HbA1c',
                            value: a1c == null ? '-' : '${a1c.toStringAsFixed(1)}%',
                            caption: a1c == null ? 'needs 5+ readings' : HealthAnalytics.hba1cStatus(a1c).label,
                            valueColor: a1c == null ? null : HealthAnalytics.hba1cStatus(a1c).color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TrendLineChart(
                      unit: 'mg/dL',
                      bandLow: 70,
                      bandHigh: controller.typeFilter.value == 'Fasting' ? 99 : 140,
                      series: [
                        TrendSeries(
                          label: 'Glucose',
                          color: const Color(0xFFFB8C00),
                          points: list
                              .where((r) => r.recordDate != null)
                              .map((r) => TrendPoint(r.recordDate!, controller.mgdl(r)))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SectionTitle('Readings', trailing: Text('${list.length}', style: GoogleFonts.outfit(color: Colors.grey))),
              ChoiceChipsRow<String>(
                values: ['All', ...DiabetesReportController.readingTypes],
                selected: controller.typeFilter.value,
                labelOf: (t) => t == 'Post Prandial (PP)' ? 'After Meal' : t,
                onSelected: (t) => controller.typeFilter.value = t,
              ),
              const SizedBox(height: 12),
              if (list.isEmpty)
                const HealthEmptyState(
                    icon: Icons.filter_alt_off_rounded, title: 'No readings here', subtitle: 'Try another filter.'),
              for (final r in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DiabetesRecordCard(
                    record: r,
                    isDark: isDark,
                    status: controller.status(r),
                    onTap: () => Get.toNamed(Routes.addDiabetesRecord, arguments: r),
                    onDelete: () async {
                      if (await confirmDelete(context,
                          title: 'Delete Reading?', message: 'This blood sugar entry will be permanently removed.')) {
                        controller.deleteRecord(r.id!);
                      }
                    },
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                'Targets (ADA): fasting 70-99 mg/dL, 2 hrs after meal below 140 mg/dL. '
                'Estimated HbA1c is calculated from your logged readings and is not a lab result. '
                'Tap a reading to edit, long-press to delete.',
                style: GoogleFonts.outfit(fontSize: 10.5, color: Colors.grey, height: 1.4),
              ),
            ],
          );
        }),
      ),
    );
  }
}
