import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../routes/app_pages.dart';
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
        title: Text('Pressure Report', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(Icons.ios_share_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
                tooltip: 'Share All',
                onPressed: controller.records.isEmpty
                    ? null
                    : () => PdfExportService.sharePressureRecords(controller.records),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.addPressureRecord),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: ResponsiveLayout(
        mobile: Obx(() {
          if (controller.records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No pressure readings yet',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap + to log your first reading.',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
            physics: const BouncingScrollPhysics(),
            itemCount: controller.records.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = controller.records[index];
              return PressureRecordCard(
                record: record,
                isDark: isDark,
                category: controller.category(record),
                isHigh: controller.isHigh(record),
                onDelete: () => _confirmDelete(context, record.id!),
              );
            },
          );
        }),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Reading?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text('This pressure entry will be permanently removed.', style: GoogleFonts.outfit()),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel', style: GoogleFonts.outfit())),
          TextButton(
            onPressed: () {
              controller.deleteRecord(id);
              Get.back();
            },
            child: Text('Delete', style: GoogleFonts.outfit(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
