import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../routes/app_pages.dart';
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
        title: Text('Test Report History', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.addTestReport),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: ResponsiveLayout(
        mobile: Obx(() {
          final grouped = controller.groupedByMonth;

          if (controller.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.biotech_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No test reports added yet',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap + to add your first lab result.',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
            physics: const BouncingScrollPhysics(),
            children: grouped.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 4),
                      child: Text(
                        entry.key,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...entry.value.map((report) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TestReportCard(
                            report: report,
                            isDark: isDark,
                            onDelete: () => _confirmDelete(context, report.id!),
                          ),
                        )),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Report?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text('This test report entry will be permanently removed.', style: GoogleFonts.outfit()),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel', style: GoogleFonts.outfit())),
          TextButton(
            onPressed: () {
              controller.deleteReport(id);
              Get.back();
            },
            child: Text('Delete', style: GoogleFonts.outfit(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
