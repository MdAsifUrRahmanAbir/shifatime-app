import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medicine_controller.dart';
import '../../../data/models/medicine_model.dart';
import 'package:flutter/cupertino.dart';

class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  final MedicineController controller = Get.find<MedicineController>();
  final TextEditingController nameController = TextEditingController();

  String selectedType = 'Tablet';
  int dosage = 1;
  String mealRelation = 'After Meal';
  List<String> reminderTimes = [];

  final List<Map<String, dynamic>> doseTypes = [
    {'name': 'Tablet', 'icon': Icons.medication},
    {'name': 'Syrup', 'icon': Icons.water_drop},
    {'name': 'Injection', 'icon': Icons.vaccines},
    {'name': 'Capsule', 'icon': Icons.medication_liquid},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medicine'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Name
            const Text(
              'Medicine Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Search or type medicine name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 24),

            // Dose Type
            const Text(
              'Dose Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: doseTypes.map((type) {
                final isSelected = selectedType == type['name'];
                return GestureDetector(
                  onTap: () => setState(() => selectedType = type['name']),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Get.theme.primaryColor
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Get.theme.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          type['icon'],
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        type['name'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Get.theme.primaryColor
                              : Colors.grey[600],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Dosage Picker
            const Text(
              'Dosage',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (dosage > 1) setState(() => dosage--);
                    },
                  ),
                  Expanded(
                    child: Text(
                      '$dosage $selectedType(s)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => dosage++),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Meal Relation
            const Text(
              'Meal Relation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMealChip('Before Meal', Icons.restaurant_menu),
                const SizedBox(width: 8),
                _buildMealChip('After Meal', Icons.flatware),
                const SizedBox(width: 8),
                _buildMealChip('Empty Stomach', Icons.no_food),
              ],
            ),
            const SizedBox(height: 24),

            // Reminder Times (Hybrid: Chips + Custom)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reminder Times',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  onPressed: _pickCustomTime,
                  icon: const Icon(Icons.add_alarm, size: 20),
                  label: const Text('Add Custom'),
                  style: TextButton.styleFrom(
                    foregroundColor: Get.theme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeSlotChip('Sokal', Icons.wb_sunny_outlined),
                _buildTimeSlotChip('Dupur', Icons.wb_sunny),
                _buildTimeSlotChip('Bikal', Icons.wb_cloudy_outlined),
                _buildTimeSlotChip('Rat', Icons.nightlight_round_outlined),
              ],
            ),

            // Display Custom Times
            if (reminderTimes.any(
              (t) => !['Sokal', 'Dupur', 'Bikal', 'Rat'].contains(t),
            ))
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reminderTimes
                      .where(
                        (t) => !['Sokal', 'Dupur', 'Bikal', 'Rat'].contains(t),
                      )
                      .map(
                        (time) => Chip(
                          label: Text(time),
                          onDeleted: () =>
                              setState(() => reminderTimes.remove(time)),
                          deleteIcon: const Icon(Icons.cancel, size: 16),
                          backgroundColor: Colors.grey[100],
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveMedicine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Schedule',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickCustomTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Get.theme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final String timeStr =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (!reminderTimes.contains(timeStr)) {
        setState(() => reminderTimes.add(timeStr));
      }
    }
  }

  Widget _buildTimeSlotChip(String label, IconData icon) {
    final isSelected = reminderTimes.contains(label);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              reminderTimes.remove(label);
            } else {
              reminderTimes.add(label);
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Get.theme.primaryColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Get.theme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealChip(String label, IconData icon) {
    final isSelected = mealRelation == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => mealRelation = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Get.theme.primaryColor.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Get.theme.primaryColor : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Get.theme.primaryColor : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Get.theme.primaryColor : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveMedicine() {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter medicine name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (reminderTimes.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one reminder time',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final medicine = Medicine(
      name: nameController.text,
      type: selectedType,
      dosage: dosage,
      mealRelation: mealRelation,
      reminderTimes: reminderTimes,
    );

    controller.addMedicine(medicine);
    Get.back();
    Get.snackbar(
      'Success',
      'Medicine scheduled successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
