import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/health_analytics.dart';
import '../../../data/lab_test_catalog.dart';
import '../../../data/models/test_report_model.dart';
import '../../../widgets/health_widgets.dart';
import '../controllers/test_report_controller.dart';

class TestReportCard extends StatelessWidget {
  final TestReport report;
  final bool isDark;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TestReportCard({
    super.key,
    required this.report,
    required this.isDark,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = LabTestCatalog.colorFor(report.category);
    final params = report.allParameters;
    final flagged = TestReportController.flagged(report);
    final meta = [
      if (report.testDate != null) DateFormat('dd MMM yyyy').format(report.testDate!),
      if ((report.labName ?? '').isNotEmpty) report.labName!,
    ].join(' • ');

    return HealthCard(
      onTap: onTap,
      onLongPress: onDelete,
      borderColor: flagged.isNotEmpty ? AppColors.error.withValues(alpha: 0.25) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: Icon(LabTestCatalog.iconFor(report.category), color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.testName ?? 'Lab Test',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(meta, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusPill(
                    flagged.isEmpty
                        ? const HealthStatus('All Normal', HealthLevel.normal)
                        : HealthStatus('${flagged.length} Abnormal', HealthLevel.high),
                  ),
                  const SizedBox(height: 4),
                  Text('${params.length} result${params.length == 1 ? '' : 's'}',
                      style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          if (flagged.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final f in flagged.take(4))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: f.$2.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${f.$1.name}: ${f.$1.value}${f.$2.level == HealthLevel.low ? ' ↓' : ' ↑'}',
                      style: GoogleFonts.outfit(fontSize: 11, color: f.$2.color, fontWeight: FontWeight.w600),
                    ),
                  ),
                if (flagged.length > 4)
                  Text('+${flagged.length - 4} more', style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
