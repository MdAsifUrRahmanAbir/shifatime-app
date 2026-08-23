import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';
import '../../medicine/controllers/medicine_controller.dart';

class InventoryMedicineCard extends GetView<MedicineController> {
  final Medicine medicine;
  final bool isDark;

  const InventoryMedicineCard({super.key, required this.medicine, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final hasStock = medicine.totalStock != null;
    final isLow = hasStock && (medicine.totalStock! <= (medicine.stockThreshold ?? 5));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLow
              ? Colors.redAccent.withValues(alpha: 0.3)
              : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name ?? 'Pill',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dosage: ${medicine.customDosage ?? "${medicine.dosage} ${medicine.type}(s)"}',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isLow
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : (hasStock ? Colors.green.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  hasStock ? '${medicine.totalStock} remaining' : 'Unlimited Stock',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isLow ? Colors.redAccent : (hasStock ? Colors.green : Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          if (hasStock) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Refill Medicine Stock',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    _buildRefillButton(10, '+10'),
                    const SizedBox(width: 8),
                    _buildRefillButton(30, '+30'),
                    const SizedBox(width: 8),
                    _buildRefillButton(50, '+50'),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRefillButton(int amount, String label) {
    return GestureDetector(
      onTap: () async {
        medicine.totalStock = (medicine.totalStock ?? 0) + amount;
        await medicine.save();
        controller.medicines.refresh();
        Get.snackbar(
          'Stock Refilled! 📦',
          'Successfully refilled ${medicine.name} by $amount counts.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
