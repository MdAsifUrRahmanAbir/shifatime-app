import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../data/lab_test_catalog.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/health_widgets.dart';
import '../controllers/test_report_controller.dart';
import '../widgets/test_report_card.dart';

class TestReportView extends GetView<TestReportController> {
  const TestReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Lab Test Reports', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
                    : () => PdfExportService.shareTestReports(controller.filtered),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.addTestReport),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Report', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ResponsiveLayout(
        mobile: Obx(() {
          if (controller.reports.isEmpty) {
            return const Center(
              child: HealthEmptyState(
                icon: Icons.biotech_outlined,
                title: 'No lab reports yet',
                subtitle: 'Tap "Add Report", pick a test like CBC or Lipid Profile,\n'
                    'and type the results from your report.',
              ),
            );
          }

          final grouped = controller.groupedByMonth;
          final latest = controller.reports.first;
          final abnormal = controller.abnormalInLatest;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            physics: const BouncingScrollPhysics(),
            children: [
              HealthCard(
                child: Row(
                  children: [
                    Expanded(child: StatTile(label: 'Reports', value: '${controller.reports.length}')),
                    Expanded(
                      child: StatTile(
                        label: 'Last test',
                        value: latest.testDate != null ? DateFormat('dd MMM').format(latest.testDate!) : '-',
                        caption: latest.category == LabTestCatalog.custom
                            ? latest.testName
                            : LabTestCatalog.byName(latest.category)?.short ?? latest.testName,
                      ),
                    ),
                    Expanded(
                      child: StatTile(
                        label: 'Need attention',
                        value: '$abnormal',
                        caption: 'in latest results',
                        valueColor: abnormal > 0 ? AppColors.error : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (controller.categories.length > 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: ChoiceChipsRow<String>(
                    values: controller.categories,
                    selected: controller.categoryFilter.value,
                    labelOf: (c) => c == 'All' ? 'All' : (LabTestCatalog.byName(c)?.short ?? 'Other'),
                    onSelected: (c) => controller.categoryFilter.value = c,
                  ),
                ),
              for (final entry in grouped.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 4, top: 4),
                  child: Text(entry.key,
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                for (final report in entry.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TestReportCard(
                      report: report,
                      isDark: isDark,
                      onTap: () => Get.toNamed(Routes.testReportDetail, arguments: report.id),
                      onDelete: () async {
                        if (await confirmDelete(context,
                            title: 'Delete Report?', message: 'This lab report will be permanently removed.')) {
                          controller.deleteReport(report.id!);
                        }
                      },
                    ),
                  ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
