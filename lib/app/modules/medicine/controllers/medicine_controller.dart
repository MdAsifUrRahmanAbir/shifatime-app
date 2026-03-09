import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/medicine_model.dart';
import '../../../core/services/notification_service.dart';

class MedicineController extends GetxController {
  final Box<Medicine> medicineBox = Hive.box<Medicine>('medicines');

  var medicines = <Medicine>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
  }

  final Map<String, String> timeSlots = {
    'Sokal': '08:00',
    'Dupur': '14:00',
    'Bikal': '17:00',
    'Rat': '22:00',
  };

  void loadMedicines() {
    medicines.assignAll(medicineBox.values.toList());
  }

  Future<void> addMedicine(Medicine medicine) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    medicine.id = id;
    await medicineBox.put(id, medicine);
    medicines.add(medicine);

    // Schedule notifications
    _scheduleNotifications(medicine);
  }

  Future<void> deleteMedicine(String id) async {
    await medicineBox.delete(id);
    medicines.removeWhere((m) => m.id == id);

    // Cancel notifications (id based or common prefix)
    // For simplicity, we can use a hash of ID + index
    for (int i = 0; i < 5; i++) {
      // Assuming max 5 reminders per medicine
      await NotificationService.cancelNotification(id.hashCode + i);
    }
  }

  void _scheduleNotifications(Medicine medicine) {
    if (!medicine.isActive! || medicine.reminderTimes == null) return;

    for (int i = 0; i < medicine.reminderTimes!.length; i++) {
      String timeStr = medicine.reminderTimes![i];

      // Map label to time if it exists in slots
      if (timeSlots.containsKey(timeStr)) {
        timeStr = timeSlots[timeStr]!;
      }

      final parts = timeStr.split(':');
      if (parts.length != 2) continue;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      // If time is in the past, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      NotificationService.scheduleNotification(
        id: medicine.id.hashCode + i,
        title: 'Time for your ${medicine.name}',
        body:
            'Take ${medicine.dosage} ${medicine.type} (${medicine.mealRelation})',
        scheduledDate: scheduledDate,
      );
    }
  }

  Future<void> toggleMedicineStatus(Medicine medicine) async {
    medicine.isActive = !medicine.isActive!;
    await medicine.save();

    if (medicine.isActive!) {
      _scheduleNotifications(medicine);
    } else {
      for (int i = 0; i < (medicine.reminderTimes?.length ?? 0); i++) {
        await NotificationService.cancelNotification(medicine.id.hashCode + i);
      }
    }
    medicines.refresh();
  }
}
