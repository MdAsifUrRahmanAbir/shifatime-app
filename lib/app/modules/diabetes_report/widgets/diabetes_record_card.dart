import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../data/models/diabetes_record_model.dart';

class DiabetesRecordCard extends StatelessWidget {
  final DiabetesRecord record;
  final bool isDark;
  final bool isHigh;
  final VoidCallback? onDelete;

  const DiabetesRecordCard({
    super.key,
    required this.record,
    required this.isDark,
    required this.isHigh,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHigh
                ? Colors.redAccent.withValues(alpha: 0.3)
                : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isHigh ? AppColors.error : AppColors.primary).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.water_drop_rounded, color: isHigh ? AppColors.error : AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.readingType ?? 'Reading',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.recordDate != null
                        ? DateFormat('dd MMM, yyyy • hh:mm a').format(record.recordDate!)
                        : '',
                    style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${record.value?.toStringAsFixed(1) ?? '-'}',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isHigh ? AppColors.error : AppColors.textPrimary,
                  ),
                ),
                Text(
                  record.unit ?? 'mg/dL',
                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => PdfExportService.shareSingleDiabetesRecord(record),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.ios_share_rounded, size: 18, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
