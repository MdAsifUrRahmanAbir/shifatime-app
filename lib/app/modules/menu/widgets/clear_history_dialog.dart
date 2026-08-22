import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void showClearHistoryDialog(Box logBox) {
  Get.defaultDialog(
    title: 'Clear History',
    titleStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
    middleText: 'Are you sure you want to delete all activity and notification logs?',
    middleTextStyle: GoogleFonts.outfit(),
    textConfirm: 'Clear All',
    textCancel: 'Cancel',
    confirmTextColor: Colors.white,
    buttonColor: Colors.redAccent,
    onConfirm: () {
      logBox.clear();
      Get.back();
      Get.snackbar(
        'History Cleared 🧹',
        'Successfully deleted history log records.',
        snackPosition: SnackPosition.BOTTOM,
      );
    },
  );
}
