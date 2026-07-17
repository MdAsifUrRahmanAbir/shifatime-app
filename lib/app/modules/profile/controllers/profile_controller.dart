import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/notification_service.dart';

class ProfileController extends GetxController {
  final name = ''.obs;
  final age = 0.obs;
  final height = 0.0.obs;
  final weight = 0.0.obs;
  final waterTarget = 0.0.obs;
  final gender = 'Male'.obs;

  final bmi = 0.0.obs;
  final bmiCategory = ''.obs;
  final healthAdvice = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    name.value = LocalStorage.getName();
    age.value = LocalStorage.getAge();
    height.value = LocalStorage.getHeight();
    weight.value = LocalStorage.getWeight();
    waterTarget.value = LocalStorage.getWaterTarget();
    gender.value = LocalStorage.getGender();

    _calculateBMI();
  }

  void _calculateBMI() {
    if (height.value > 0 && weight.value > 0) {
      final heightInMeters = height.value / 100.0;
      final calculatedBmi = weight.value / (heightInMeters * heightInMeters);
      bmi.value = double.parse(calculatedBmi.toStringAsFixed(2));

      if (bmi.value < 18.5) {
        bmiCategory.value = 'Underweight';
        healthAdvice.value = 'Focus on nutrient-dense foods, lean protein, and strength training to build muscle weight safely.';
      } else if (bmi.value < 25.0) {
        bmiCategory.value = 'Normal Weight';
        healthAdvice.value = 'Excellent! Maintain your healthy weight through regular physical activity and a balanced diet.';
      } else if (bmi.value < 30.0) {
        bmiCategory.value = 'Overweight';
        healthAdvice.value = 'Incorporate moderate cardio exercises and portion control to reduce weight and support your cardiovascular health.';
      } else {
        bmiCategory.value = 'Obese';
        healthAdvice.value = 'Consider consulting a healthcare provider or nutritionist to design a safe, sustainable weight loss and exercise plan.';
      }
    } else {
      bmi.value = 0.0;
      bmiCategory.value = 'Not Calculated';
      healthAdvice.value = 'Complete your profile details to calculate BMI and get health suggestions.';
    }
  }

  Future<void> saveProfileDetails({
    required String nameVal,
    required int ageVal,
    required double heightVal,
    required double weightVal,
    required String genderVal,
    double? customWaterTarget,
  }) async {
    final double calculatedWaterTarget = customWaterTarget ?? (weightVal * 35.0);

    await LocalStorage.saveProfile(
      name: nameVal,
      age: ageVal,
      height: heightVal,
      weight: weightVal,
      waterTarget: calculatedWaterTarget,
      gender: genderVal,
    );

    loadProfile();

    // Schedule daily water reminder alarms
    await NotificationService.scheduleDailyWaterReminders();
  }
}
