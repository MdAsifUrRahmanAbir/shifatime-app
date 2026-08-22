import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';

void showMedicineDeleteDialog(Medicine medicine, VoidCallback onConfirm) {
  Get.defaultDialog(
    title: 'Delete Medicine',
    titleStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    middleText: 'Are you sure you want to delete ${medicine.name}?',
    middleTextStyle: GoogleFonts.outfit(),
    textConfirm: 'Delete',
    textCancel: 'Cancel',
    confirmTextColor: Colors.white,
    buttonColor: AppColors.error,
    onConfirm: () {
      onConfirm();
      Get.back();
    },
  );
}
