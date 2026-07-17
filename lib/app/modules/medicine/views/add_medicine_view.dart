import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/medicine_controller.dart';
import '../../../data/models/medicine_model.dart';
import '../../../core/constants/app_colors.dart';

class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  final MedicineController controller = Get.find<MedicineController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController totalStockController = TextEditingController();
  final TextEditingController thresholdController = TextEditingController(text: '5');
  final TextEditingController customDosageController = TextEditingController(text: '1 Tablet');
  final TextEditingController usageInstructionController = TextEditingController();
  final TextEditingController durationValueController = TextEditingController(text: '7');

  String selectedType = 'Tablet';
  String customDosage = '1 Tablet';
  String mealRelation = 'After Meal';
  List<String> reminderTimes = [];

  // Schedule & Recurrence State
  String selectedScheduleType = 'Daily'; // Daily, Weekdays, Interval
  List<String> selectedWeekDays = [];
  int intervalHours = 8; // 6, 8, 12, 24
  TimeOfDay intervalStartTime = const TimeOfDay(hour: 8, minute: 0);

  // Duration State
  String durationLimitType = 'Until Stopped'; // Until Stopped, Specified
  String durationUnit = 'Days'; // Days, Weeks, Months

  final List<String> weekDays = [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  final List<Map<String, dynamic>> doseTypes = [
    {'name': 'Tablet', 'icon': Icons.medication_rounded},
    {'name': 'Capsule', 'icon': Icons.medication_liquid_rounded},
    {'name': 'Syrup', 'icon': Icons.water_drop_rounded},
    {'name': 'Injection', 'icon': Icons.vaccines_rounded},
    {'name': 'Cream', 'icon': Icons.healing_rounded},
    {'name': 'Eye Drop', 'icon': Icons.remove_red_eye_rounded},
    {'name': 'Ear Drop', 'icon': Icons.hearing_rounded},
    {'name': 'Nasal Spray', 'icon': Icons.air_rounded},
    {'name': 'Inhaler', 'icon': Icons.bubble_chart_rounded},
    {'name': 'Patch', 'icon': Icons.crop_landscape_rounded},
    {'name': 'Other', 'icon': Icons.help_outline_rounded},
  ];

  String? selectedAppArea;

  final List<String> instructionPresets = [
    'Apply only at night',
    'Shake well before use',
    'Store in refrigerator',
    'Avoid direct sunlight',
    'Wash face before applying',
    'Remove lenses before using eye drops',
  ];

  @override
  void dispose() {
    nameController.dispose();
    totalStockController.dispose();
    thresholdController.dispose();
    customDosageController.dispose();
    usageInstructionController.dispose();
    durationValueController.dispose();
    super.dispose();
  }

  List<String> _getDosageSuggestions(String type) {
    switch (type) {
      case 'Tablet':
        return ['1 Tablet', '2 Tablets', '0.5 Tablet', '1.5 Tablets'];
      case 'Capsule':
        return ['1 Capsule', '2 Capsules'];
      case 'Syrup':
        return ['5 ml', '10 ml', '15 ml', '2.5 ml', '7.5 ml'];
      case 'Injection':
        return ['1 Injection', '0.5 ml', '1 ml', '2 ml'];
      case 'Cream':
        return ['Apply Thin Layer', 'Apply Moderate Layer', 'Apply Generously', '1 Application'];
      case 'Eye Drop':
        return ['1 Drop', '2 Drops', '3 Drops'];
      case 'Ear Drop':
        return ['2 Drops', '1 Drop', '3 Drops'];
      case 'Nasal Spray':
        return ['1 Spray Each Nostril', '2 Sprays Each Nostril', '1 Spray', '2 Sprays'];
      case 'Inhaler':
        return ['1 Puff', '2 Puffs', '3 Puffs'];
      case 'Patch':
        return ['Apply 1 Patch', 'Apply 0.5 Patch'];
      default:
        return ['1 Dose', '2 Doses', '1 Unit'];
    }
  }

  bool _shouldShowAppArea() {
    final typeLower = selectedType.toLowerCase();
    return typeLower.contains('cream') ||
        typeLower.contains('drop') ||
        typeLower.contains('spray') ||
        typeLower.contains('patch');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Add Medicine',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Name
            Text(
              'Medicine Name',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              style: GoogleFonts.outfit(),
              decoration: InputDecoration(
                hintText: 'Enter medicine name...',
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCardBackground : Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Medicine Type (Wrap Category Selection)
            Text(
              'Medicine Type',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: doseTypes.map((type) {
                final isSelected = selectedType == type['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = type['name'];
                      final suggestions = _getDosageSuggestions(type['name']);
                      customDosage = suggestions.first;
                      customDosageController.text = suggestions.first;
                      selectedAppArea = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.limeAccent
                          : (isDark ? AppColors.darkCardBackground : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.limeAccent
                            : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type['icon'],
                          color: isSelected ? AppColors.limeDarkText : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          type['name'],
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.limeDarkText
                                : (isDark ? Colors.white70 : AppColors.textPrimary),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Dosage Section
            Text(
              'Dosage',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: _getDosageSuggestions(selectedType).map((suggest) {
                  final isSelected = customDosage == suggest;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(suggest, style: GoogleFonts.outfit(fontSize: 13)),
                      selected: isSelected,
                      selectedColor: AppColors.limeAccent,
                      backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
                      labelStyle: GoogleFonts.outfit(
                        color: isSelected
                            ? AppColors.limeDarkText
                            : (isDark ? Colors.white70 : AppColors.textPrimary),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.limeAccent
                              : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            customDosage = suggest;
                            customDosageController.text = suggest;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: customDosageController,
              style: GoogleFonts.outfit(),
              decoration: InputDecoration(
                hintText: 'Enter custom dosage details...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCardBackground : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: (val) {
                setState(() {
                  customDosage = val;
                });
              },
            ),

            // Optional Application Area (Cream, Drops, Spray, Patch)
            if (_shouldShowAppArea()) ...[
              const SizedBox(height: 24),
              Text(
                'Application Area (Optional)',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedAppArea,
                hint: Text('Select body area (e.g. Face)...', style: GoogleFonts.outfit(color: Colors.grey)),
                style: GoogleFonts.outfit(color: isDark ? Colors.white : AppColors.textPrimary),
                dropdownColor: isDark ? AppColors.darkCardBackground : Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.darkCardBackground : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                items: [
                  'Face',
                  'Forehead',
                  'Nose',
                  'Eye',
                  'Ear',
                  'Neck',
                  'Hands',
                  'Legs',
                  'Feet',
                  'Chest',
                  'Back',
                  'Custom'
                ].map((area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(area, style: GoogleFonts.outfit(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedAppArea = val;
                  });
                },
              ),
            ],
            const SizedBox(height: 24),

            // Meal Relation
            Text(
              'Meal Relation',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildMealChip('Before Meal', Icons.restaurant_menu_rounded, isDark),
                _buildMealChip('After Meal', Icons.flatware_rounded, isDark),
                _buildMealChip('Empty Stomach', Icons.no_food_rounded, isDark),
                _buildMealChip('With Meal', Icons.lunch_dining_rounded, isDark),
                _buildMealChip('Not Related', Icons.dining_outlined, isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Schedule Type Selector
            Text(
              'Schedule Type',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildScheduleTypeChip('Daily', Icons.calendar_today_rounded, isDark),
                const SizedBox(width: 8),
                _buildScheduleTypeChip('Weekdays', Icons.view_week_rounded, isDark),
                const SizedBox(width: 8),
                _buildScheduleTypeChip('Interval', Icons.repeat_rounded, isDark),
              ],
            ),

            if (selectedScheduleType == 'Weekdays') ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: weekDays.map((day) {
                  final isSelected = selectedWeekDays.contains(day);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedWeekDays.remove(day);
                        } else {
                          selectedWeekDays.add(day);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.limeAccent
                            : (isDark ? AppColors.darkCardBackground : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.limeAccent
                              : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                        ),
                      ),
                      child: Text(
                        day,
                        style: GoogleFonts.outfit(
                          color: isSelected
                              ? AppColors.limeDarkText
                              : (isDark ? Colors.white70 : Colors.grey[700]),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            if (selectedScheduleType == 'Interval') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trigger Interval',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: intervalHours,
                      style: GoogleFonts.outfit(color: isDark ? Colors.white : AppColors.textPrimary),
                      dropdownColor: isDark ? AppColors.darkCardBackground : Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? Colors.black26 : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      items: [6, 8, 12, 24].map((hours) {
                        return DropdownMenuItem<int>(
                          value: hours,
                          child: Text('Every $hours Hours', style: GoogleFonts.outfit()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => intervalHours = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('First Alarm Time', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                        TextButton.icon(
                          onPressed: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: intervalStartTime,
                            );
                            if (time != null) setState(() => intervalStartTime = time);
                          },
                          icon: const Icon(Icons.access_time_rounded, size: 16),
                          label: Text(intervalStartTime.format(context), style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      'Reminder alarms will be set automatically for all interval loops.',
                      style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Duration Section
            Text(
              'Duration',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text('Until Stopped', style: GoogleFonts.outfit()),
                    selected: durationLimitType == 'Until Stopped',
                    selectedColor: AppColors.limeAccent,
                    backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
                    labelStyle: GoogleFonts.outfit(
                      color: durationLimitType == 'Until Stopped' ? AppColors.limeDarkText : (isDark ? Colors.white70 : AppColors.textPrimary),
                      fontWeight: durationLimitType == 'Until Stopped' ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => durationLimitType = 'Until Stopped');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text('Specified Days', style: GoogleFonts.outfit()),
                    selected: durationLimitType == 'Specified',
                    selectedColor: AppColors.limeAccent,
                    backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
                    labelStyle: GoogleFonts.outfit(
                      color: durationLimitType == 'Specified' ? AppColors.limeDarkText : (isDark ? Colors.white70 : AppColors.textPrimary),
                      fontWeight: durationLimitType == 'Specified' ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => durationLimitType = 'Specified');
                    },
                  ),
                ),
              ],
            ),

            if (durationLimitType == 'Specified') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: durationValueController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.outfit(),
                      decoration: InputDecoration(
                        labelText: 'Duration',
                        labelStyle: GoogleFonts.outfit(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark ? AppColors.darkCardBackground : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBackground : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: durationUnit,
                          style: GoogleFonts.outfit(
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                          dropdownColor: isDark ? AppColors.darkCardBackground : Colors.white,
                          isExpanded: true,
                          items: ['Days', 'Weeks', 'Months'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.outfit()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() => durationUnit = newValue!);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),

            // Reminder Times (Only show if not Interval schedule)
            if (selectedScheduleType != 'Interval') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reminder Times',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton.icon(
                    onPressed: _pickCustomTime,
                    icon: const Icon(Icons.add_alarm_rounded, size: 20),
                    label: Text('Add Custom', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeSlotChip('Sokal', 'Morning', Icons.wb_sunny_outlined, isDark),
                  _buildTimeSlotChip('Dupur', 'Afternoon', Icons.wb_sunny_rounded, isDark),
                  _buildTimeSlotChip('Bikal', 'Evening', Icons.wb_cloudy_outlined, isDark),
                  _buildTimeSlotChip('Rat', 'Night', Icons.nightlight_round_outlined, isDark),
                ],
              ),

              // Display Custom Times
              if (reminderTimes.any((t) => !['Sokal', 'Dupur', 'Bikal', 'Rat'].contains(t)))
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: reminderTimes
                        .where((t) => !['Sokal', 'Dupur', 'Bikal', 'Rat'].contains(t))
                        .map((time) => Chip(
                              label: Text(time, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                              backgroundColor: AppColors.limeAccent,
                              labelStyle: const TextStyle(color: AppColors.limeDarkText),
                              deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.limeDarkText),
                              onDeleted: () {
                                setState(() => reminderTimes.remove(time));
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 24),
            ],

            // Usage Instruction & Notes
            Text(
              'Usage Instruction & Notes (Optional)',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: usageInstructionController,
              maxLines: 2,
              style: GoogleFonts.outfit(),
              decoration: InputDecoration(
                hintText: 'e.g. Shake well before use. Take with warm water.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCardBackground : Colors.white,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: instructionPresets.map((preset) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(preset, style: GoogleFonts.outfit(fontSize: 12)),
                      backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        setState(() {
                          final currentText = usageInstructionController.text.trim();
                          if (currentText.isEmpty) {
                            usageInstructionController.text = preset;
                          } else {
                            usageInstructionController.text = '$currentText. $preset';
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Stock Management (Optional)
            Text(
              'Stock Management (Optional)',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Quantity',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: totalStockController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.outfit(),
                              decoration: InputDecoration(
                                hintText: 'e.g. 30',
                                filled: true,
                                fillColor: isDark ? Colors.black26 : Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alert Threshold',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: thresholdController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.outfit(),
                              decoration: InputDecoration(
                                hintText: 'e.g. 5',
                                filled: true,
                                fillColor: isDark ? Colors.black26 : Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Schedule',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
    if (picked != null) {
      final String timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (!reminderTimes.contains(timeStr)) {
        setState(() => reminderTimes.add(timeStr));
      }
    }
  }

  Widget _buildTimeSlotChip(String value, String display, IconData icon, bool isDark) {
    final isSelected = reminderTimes.contains(value);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              reminderTimes.remove(value);
            } else {
              reminderTimes.add(value);
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.limeAccent : (isDark ? AppColors.darkCardBackground : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.limeAccent : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.limeDarkText : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                display,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.limeDarkText : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealChip(String label, IconData icon, bool isDark) {
    final isSelected = mealRelation == label;
    return ChoiceChip(
      avatar: Icon(icon, color: isSelected ? AppColors.limeDarkText : Colors.grey[600], size: 18),
      label: Text(label, style: GoogleFonts.outfit(fontSize: 12)),
      selected: isSelected,
      selectedColor: AppColors.limeAccent,
      backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
      labelStyle: GoogleFonts.outfit(
        color: isSelected ? AppColors.limeDarkText : (isDark ? Colors.white70 : AppColors.textPrimary),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppColors.limeAccent : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      onSelected: (selected) {
        if (selected) setState(() => mealRelation = label);
      },
    );
  }

  Widget _buildScheduleTypeChip(String label, IconData icon, bool isDark) {
    final isSelected = selectedScheduleType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedScheduleType = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.limeAccent : (isDark ? AppColors.darkCardBackground : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.limeAccent : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.limeDarkText : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.limeDarkText : Colors.grey[600],
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
        'Error ⚠️',
        'Please enter medicine name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    List<String> finalTimes = [];
    if (selectedScheduleType == 'Interval') {
      final hour = intervalStartTime.hour;
      final minute = intervalStartTime.minute;
      final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      
      if (intervalHours == 24) {
        finalTimes = [timeStr];
      } else if (intervalHours == 12) {
        finalTimes = [
          timeStr,
          '${((hour + 12) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'
        ];
      } else if (intervalHours == 8) {
        finalTimes = [
          timeStr,
          '${((hour + 8) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          '${((hour + 16) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'
        ];
      } else if (intervalHours == 6) {
        finalTimes = [
          timeStr,
          '${((hour + 6) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          '${((hour + 12) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          '${((hour + 18) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'
        ];
      }
    } else {
      if (reminderTimes.isEmpty) {
        Get.snackbar(
          'Error ⚠️',
          'Please add at least one reminder time',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      finalTimes = List.from(reminderTimes);
    }

    final totalStock = int.tryParse(totalStockController.text.trim());
    final threshold = int.tryParse(thresholdController.text.trim()) ?? 5;

    // Estimate numerical dosage size for stock subtraction logic
    int dosageInt = 1;
    final regex = RegExp(r'^(\d+(\.\d+)?)');
    final match = regex.firstMatch(customDosage);
    if (match != null) {
      dosageInt = double.tryParse(match.group(1)!)?.round() ?? 1;
    }

    final medicine = Medicine(
      name: nameController.text.trim(),
      type: selectedType,
      dosage: dosageInt,
      mealRelation: mealRelation,
      reminderTimes: finalTimes,
      durationType: selectedScheduleType == 'Weekdays'
          ? 'Specific Days'
          : (durationLimitType == 'Until Stopped' ? 'Nonstop' : 'Specified'),
      durationValue: selectedScheduleType == 'Weekdays'
          ? selectedWeekDays.join(',')
          : (durationLimitType == 'Specified' ? durationValueController.text.trim() : null),
      durationUnit: durationLimitType == 'Specified' ? durationUnit : null,
      totalStock: totalStock,
      stockThreshold: threshold,
      isStockAlertEnabled: totalStock != null,
      customDosage: customDosage,
      applicationArea: _shouldShowAppArea() ? selectedAppArea : null,
      usageInstruction: usageInstructionController.text.trim(),
    );

    controller.addMedicine(medicine);
    Get.back();
    Get.snackbar(
      'Success 🎉',
      'Medicine scheduled successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
