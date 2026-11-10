import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/health_analytics.dart';
import '../../../data/models/pressure_record_model.dart';
import '../../../widgets/health_widgets.dart';

class PressureRecordCard extends StatelessWidget {
  final PressureRecord record;
  final bool isDark;
  final HealthStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PressureRecordCard({
    super.key,
    required this.record,
    required this.isDark,
    required this.status,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final extras = [
      if (record.pulse != null) 'Pulse ${record.pulse} bpm',
      if ((record.arm ?? '').isNotEmpty) '${record.arm} arm',
    ].join(' • ');

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
            child: Icon(Icons.favorite_rounded, color: status.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusPill(status, fontSize: 11),
                const SizedBox(height: 4),
                Text(
                  record.recordDate != null ? DateFormat('dd MMM yyyy • hh:mm a').format(record.recordDate!) : '',
                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                ),
                if (extras.isNotEmpty)
                  Text(extras, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${record.systolic ?? '-'}/${record.diastolic ?? '-'}',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: status.isAbnormal ? status.color : (isDark ? Colors.white : AppColors.textPrimary),
                  ),
                ),
                TextSpan(text: '\nmmHg', style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
