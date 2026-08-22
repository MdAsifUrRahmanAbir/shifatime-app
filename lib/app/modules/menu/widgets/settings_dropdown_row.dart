import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsDropdownRow<T> extends StatelessWidget {
  final String title;
  final String desc;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const SettingsDropdownRow({
    super.key,
    required this.title,
    required this.desc,
    required this.value,
    required this.items,
    required this.onChanged,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
