import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medicine_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/medicine_model.dart';

class MedicineView extends GetView<MedicineController> {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShifaTime'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(Routes.profile),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.medicines.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No medicines scheduled yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.medicines.length,
          itemBuilder: (context, index) {
            final medicine = controller.medicines[index];
            return _buildMedicineCard(medicine);
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.addMedicine),
        label: const Text('Add Medicine'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicineCard(Medicine medicine) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
          child: Icon(
            _getIconForType(medicine.type),
            color: Get.theme.primaryColor,
          ),
        ),
        title: Text(
          medicine.name ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${medicine.dosage} ${medicine.type} • ${medicine.mealRelation}',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (medicine.reminderTimes ?? []).map((time) {
                return Chip(
                  avatar: Icon(
                    _getIconForTime(time),
                    size: 14,
                    color: Get.theme.primaryColor,
                  ),
                  label: Text(time, style: const TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Get.theme.primaryColor.withOpacity(0.05),
                );
              }).toList(),
            ),
          ],
        ),
        trailing: Switch(
          value: medicine.isActive ?? true,
          onChanged: (value) => controller.toggleMedicineStatus(medicine),
        ),
        onLongPress: () {
          Get.defaultDialog(
            title: 'Delete Medicine',
            middleText: 'Are you sure you want to delete ${medicine.name}?',
            textConfirm: 'Delete',
            textCancel: 'Cancel',
            confirmTextColor: Colors.white,
            onConfirm: () {
              controller.deleteMedicine(medicine.id!);
              Get.back();
            },
          );
        },
      ),
    );
  }

  IconData _getIconForTime(String time) {
    switch (time) {
      case 'Sokal':
        return Icons.wb_sunny_outlined;
      case 'Dupur':
        return Icons.wb_sunny;
      case 'Bikal':
        return Icons.wb_cloudy_outlined;
      case 'Rat':
        return Icons.nightlight_round_outlined;
      default:
        return Icons.access_time;
    }
  }

  IconData _getIconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'tablet':
        return Icons.medication;
      case 'syrup':
        return Icons.water_drop;
      case 'injection':
        return Icons.vaccines;
      case 'capsule':
        return Icons.medication_liquid;
      default:
        return Icons.medical_services;
    }
  }
}
