import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// PrimaryDatePicker — labeled date selector input.
class PrimaryDatePicker extends StatelessWidget {
  final String? label;
  final String hint;
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const PrimaryDatePicker({
    super.key,
    this.label,
    this.hint = 'Select date',
    this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayText = selectedDate != null
        ? DateFormat('dd MMM, yyyy').format(selectedDate!)
        : hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: AppSizes.fontSmall,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall - 2),
        ],
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            height: AppSizes.inputFieldHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMid,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardBackground
                  : AppColors.greyLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppSizes.iconSmall,
                  color: AppColors.textHint,
                ),
                const SizedBox(width: AppSizes.gapXSmall),
                Text(
                  displayText,
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: selectedDate != null
                        ? (isDark ? AppColors.textLight : AppColors.textPrimary)
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
