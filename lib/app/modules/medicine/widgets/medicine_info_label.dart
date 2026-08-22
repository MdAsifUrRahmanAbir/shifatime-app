import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicineInfoLabel extends StatelessWidget {
  final String label;

  const MedicineInfoLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 11,
        color: Colors.grey[500],
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
