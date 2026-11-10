import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/health_widgets.dart';
import '../../../widgets/trend_line_chart.dart';
import '../controllers/pressure_report_controller.dart';
import '../widgets/pressure_record_card.dart';

class PressureReportView extends GetView<PressureReportController> {
  const PressureReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Blood Pressure', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
                    : () => PdfExportService.sharePressureRecords(controller.filtered),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.addPressureRecord),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Reading', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ResponsiveLayout(
        mobile: Obx(() {
          if (controller.records.isEmpty) {
            return const Center(
              child: HealthEmptyState(
                icon: Icons.favorite_border_rounded,
                title: 'No blood pressure readings yet',
                subtitle: 'Log readings morning and evening to see\nyour average and trend.',
              ),
            );
          }
          final list = controller.filtered;
          final latest = controller.records.first;
          final latestStatus = controller.status(latest);
          final avgStatus = controller.averageStatus;
          final s = controller.avgSystolic, d = controller.avgDiastolic, p = controller.avgPulse;
          final hi = controller.highest, lo = controller.lowest;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            physics: const BouncingScrollPhysics(),
            children: [
              HealthCard(
                borderColor: latestStatus.color.withValues(alpha: 0.35),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latest reading', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '${latest.systolic}/${latest.diastolic}',
                            style: GoogleFonts.outfit(
                                fontSize: 30, fontWeight: FontWeight.bold, color: latestStatus.color),
                          ),
                          Text(
                            'mmHg${latest.pulse != null ? '  •  Pulse ${latest.pulse} bpm' : ''}',
                            style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
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
                values: PressureReportController.periods,
                selected: controller.periodDays.value,
                labelOf: PressureReportController.periodLabel,
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
                            value: s == null ? '-' : '${s.round()}/${d!.round()}',
                            caption: avgStatus?.label ?? '',
                            valueColor: avgStatus?.color,
                          ),
                        ),
                        Expanded(
                          child: StatTile(
                            label: 'Avg pulse',
                            value: p == null ? '-' : '${p.round()}',
                            caption: p == null ? '' : 'bpm',
                          ),
                        ),
                        Expanded(
                          child: StatTile(
                            label: 'High readings',
                            value: '${controller.highCount}/${list.length}',
                            caption: 'Stage 1 or above',
                            valueColor: controller.highCount > 0 ? AppColors.error : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (hi != null && lo != null && list.length > 1) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: StatTile(label: 'Highest', value: '${hi.systolic}/${hi.diastolic}'),
                          ),
                          Expanded(
                            child: StatTile(label: 'Lowest', value: '${lo.systolic}/${lo.diastolic}'),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ],
                    const SizedBox(height: 18),
                    TrendLineChart(
                      unit: 'mmHg',
                      series: [
                        TrendSeries(
                          label: 'Systolic',
                          color: const Color(0xFFE53935),
                          points: list
                              .where((r) => r.recordDate != null)
                              .map((r) => TrendPoint(r.recordDate!, (r.systolic ?? 0).toDouble()))
                              .toList(),
                        ),
                        TrendSeries(
                          label: 'Diastolic',
                          color: const Color(0xFF1E88E5),
                          points: list
                              .where((r) => r.recordDate != null)
                              .map((r) => TrendPoint(r.recordDate!, (r.diastolic ?? 0).toDouble()))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SectionTitle('Readings', trailing: Text('${list.length}', style: GoogleFonts.outfit(color: Colors.grey))),
              if (list.isEmpty)
                const HealthEmptyState(
                    icon: Icons.event_busy_rounded, title: 'No readings in this period', subtitle: 'Try "All".'),
              for (final r in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PressureRecordCard(
                    record: r,
                    isDark: isDark,
                    status: controller.status(r),
                    onTap: () => Get.toNamed(Routes.addPressureRecord, arguments: r),
                    onDelete: () async {
                      if (await confirmDelete(context,
                          title: 'Delete Reading?', message: 'This pressure entry will be permanently removed.')) {
                        controller.deleteRecord(r.id!);
                      }
                    },
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                'Categories follow AHA guidelines: Normal below 120/80, Elevated 120-129/<80, '
                'Stage 1 130-139/80-89, Stage 2 140+/90+. Tap a reading to edit, long-press to delete.',
                style: GoogleFonts.outfit(fontSize: 10.5, color: Colors.grey, height: 1.4),
              ),
            ],
          );
        }),
      ),
    );
  }
}
