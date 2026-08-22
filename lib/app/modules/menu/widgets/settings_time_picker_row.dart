import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class SettingsTimePickerRow extends StatelessWidget {
  final String title;
  final String desc;
  final TimeOfDay time;
  final VoidCallback onTap;

  const SettingsTimePickerRow({
    super.key,
    required this.title,
    required this.desc,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(desc, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            foregroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(time.format(context), style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
