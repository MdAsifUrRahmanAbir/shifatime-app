import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../medicine/controllers/medicine_controller.dart';
import 'inventory_medicine_card.dart';

class InventoryBody extends GetView<MedicineController> {
  const InventoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final list = controller.medicines;
      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 54, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No medicines scheduled',
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          return InventoryMedicineCard(medicine: list[index], isDark: isDark);
        },
      );
    });
  }
}
