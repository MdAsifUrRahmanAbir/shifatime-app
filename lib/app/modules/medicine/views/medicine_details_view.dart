import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';
import '../controllers/medicine_controller.dart';

class MedicineDetailsView extends GetView<MedicineController> {
  const MedicineDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Medicine medicine = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pill Image and Basic Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill Illustration (Mocking with Icon for now, can use image later)
                Container(
                  width: 140,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/capsule_medicine.png',
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoLabel('Pill Name'),
                      Text(
                        medicine.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoLabel('Pill Dosage'),
                      Text(
                        '${medicine.dosage} mg',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoLabel('Next dose'),
                      Text(
                        _calculateNextDose(medicine.reminderTimes),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Detailed Sections
            _buildDetailSection(
              'Dose',
              '${medicine.reminderTimes?.length ?? 0} times | ${medicine.reminderTimes?.join(', ') ?? 'N/A'}',
            ),
            const SizedBox(height: 32),
            _buildDetailSection('Program', _formatProgram(medicine)),
            const SizedBox(height: 32),
            _buildDetailSection(
              'Meal Relation',
              medicine.mealRelation ?? 'Not specified',
            ),

            const SizedBox(height: 64),

            // Change Schedule Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to edit/add with this medicine
                  Get.back(); // For now
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Change Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[400],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDetailSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[500],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _calculateNextDose(List<String>? times) {
    if (times == null || times.isEmpty) return 'N/A';
    // For simplicity, just return the first time for now or mock "3 pm"
    return times.first;
  }

  String _formatProgram(Medicine med) {
    if (med.durationType == 'Nonstop') return 'Nonstop / Regular';
    if (med.durationType == 'Specific Days')
      return 'Specified Days: ${med.durationValue}';
    return '${med.durationValue} ${med.durationUnit} total';
  }
}
