import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../data/models/medicine_model.dart';
import '../../../data/models/dose_record_model.dart';
import '../controllers/medicine_controller.dart';
import '../widgets/full_screen_alarm_body.dart';

class FullScreenAlarmView extends StatefulWidget {
  const FullScreenAlarmView({super.key});

  @override
  State<FullScreenAlarmView> createState() => _FullScreenAlarmViewState();
}

class _FullScreenAlarmViewState extends State<FullScreenAlarmView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final MedicineController controller = Get.find<MedicineController>();
  late String doseId;
  DoseRecord? dose;
  Medicine? medicine;

  @override
  void initState() {
    super.initState();
    doseId = Get.arguments ?? '';
    dose = controller.doseBox.get(doseId);
    if (dose != null) {
      medicine = controller.medicines.firstWhereOrNull((m) => m.id == dose!.medicineId);
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dose == null) {
      return Scaffold(
        backgroundColor: AppColors.darkScaffoldBackground,
        body: Center(
          child: Text(
            'Dose details not found.',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkScaffoldBackground,
      body: ResponsiveLayout(
        mobile: FullScreenAlarmBody(
          dose: dose!,
          medicine: medicine,
          pulseAnimation: _pulseAnimation,
        ),
      ),
    );
  }
}
