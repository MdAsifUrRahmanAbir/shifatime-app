import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../data/models/medicine_model.dart';
import '../controllers/medicine_controller.dart';
import '../widgets/medicine_details_body.dart';

class MedicineDetailsView extends GetView<MedicineController> {
  const MedicineDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Medicine medicine = Get.arguments;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Medicine Details',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ResponsiveLayout(mobile: MedicineDetailsBody(medicine: medicine)),
    );
  }
}
