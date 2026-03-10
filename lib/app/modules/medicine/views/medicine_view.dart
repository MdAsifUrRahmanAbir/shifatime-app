import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/medicine_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/medicine_model.dart';

class MedicineView extends GetView<MedicineController> {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Column(
          children: [
            // Custom Header
            _buildHeader(context),

            // Weekly Calendar Bar
            _buildCalendarBar(),

            // Medicine Grid
            Expanded(
              child: Obx(() {
                if (controller.medicines.isEmpty) {
                  return _buildEmptyState();
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = controller.medicines[index];
                    return _buildMedicineGridCard(
                      medicine,
                      index == 3,
                    ); // Highlighting index 3 like in mockup
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addMedicine),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 24,
        top: MediaQuery.of(context).padding.top + 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=shifatime_user',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 32),
                onPressed: () => Get.toNamed(Routes.profile),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Medicine Reminder',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          // Custom Tab Switcher
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildTabItem('This week', true),
                _buildTabItem('This month', false),
                _buildTabItem('This year', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarBar() {
    final days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final today = 'Mon'; // Mocking "Mon" as selected like in SS

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          final isSelected = day == today;
          return Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.black87 : Colors.grey[400],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMedicineGridCard(Medicine medicine, bool isHighlighted) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.medicineDetails, arguments: medicine),
      onLongPress: () => _showDeleteDialog(medicine),
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForType(medicine.type),
              color: isHighlighted ? Colors.white : AppColors.primary,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              medicine.name ?? 'Unknown',
              style: TextStyle(
                color: isHighlighted ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${medicine.reminderTimes?.length ?? 0} times today',
              style: TextStyle(
                color: isHighlighted ? Colors.white70 : Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No medicines scheduled yet',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Medicine medicine) {
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
