import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/health_analytics.dart';
import '../../../data/models/diabetes_record_model.dart';
import '../../../widgets/health_widgets.dart';
import '../controllers/diabetes_report_controller.dart';

class DiabetesRecordCard extends StatelessWidget {
  final DiabetesRecord record;
  final bool isDark;
  final HealthStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const DiabetesRecordCard({
    super.key,
    required this.record,
    required this.isDark,
    required this.status,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final value = record.value ?? 0;
    final valueText = record.unit == 'mmol/L' ? value.toStringAsFixed(1) : value.toStringAsFixed(0);

    return HealthCard(
      onTap: onTap,
      onLongPress: onDelete,
      borderColor: status.isAbnormal ? status.color.withValues(alpha: 0.3) : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: status.color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(Icons.water_drop_rounded, color: status.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DiabetesReportController.displayType(record.readingType),
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record.recordDate != null ? DateFormat('dd MMM yyyy • hh:mm a').format(record.recordDate!) : '',
                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                ),
                if ((record.notes ?? '').isNotEmpty)
                  Text(record.notes!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: valueText,
                      style: GoogleFonts.outfit(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: status.isAbnormal ? status.color : (isDark ? Colors.white : AppColors.textPrimary),
                      ),
                    ),
                    TextSpan(
                      text: ' ${record.unit ?? 'mg/dL'}',
                      style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              StatusPill(status),
            ],
          ),
        ],
      ),
    );
  }
}
