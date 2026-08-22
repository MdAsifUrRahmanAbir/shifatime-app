import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';
import '../../medicine/controllers/medicine_controller.dart';

class MenuInventoryView extends StatelessWidget {
  final MedicineController medCtrl;
  final bool isDark;

  const MenuInventoryView({super.key, required this.medCtrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = medCtrl.medicines;
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
          final medicine = list[index];
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
                          _buildRefillButton(medicine, 10, '+10'),
                          const SizedBox(width: 8),
                          _buildRefillButton(medicine, 30, '+30'),
                          const SizedBox(width: 8),
                          _buildRefillButton(medicine, 50, '+50'),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildRefillButton(Medicine medicine, int amount, String label) {
    return GestureDetector(
      onTap: () async {
        medicine.totalStock = (medicine.totalStock ?? 0) + amount;
        await medicine.save();
        medCtrl.medicines.refresh();
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
