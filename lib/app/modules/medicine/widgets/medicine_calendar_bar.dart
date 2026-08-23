import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class MedicineCalendarBar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const MedicineCalendarBar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<MedicineCalendarBar> createState() => _MedicineCalendarBarState();
}

class _MedicineCalendarBarState extends State<MedicineCalendarBar> {
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _weekStart = _startOfWeek(widget.selectedDate);
  }

  @override
  void didUpdateWidget(covariant MedicineCalendarBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final weekEnd = _weekStart.add(const Duration(days: 6));
    if (widget.selectedDate.isBefore(_weekStart) || widget.selectedDate.isAfter(weekEnd)) {
      setState(() => _weekStart = _startOfWeek(widget.selectedDate));
    }
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday % 7)); // Sunday-start week
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _shiftWeek(int deltaDays) {
    setState(() => _weekStart = _weekStart.add(Duration(days: deltaDays)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weekDates = List.generate(7, (i) => _weekStart.add(Duration(days: i)));
    final dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(weekDates[3]),
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _shiftWeek(-7),
                  child: _buildCalArrow(isDark, Icons.arrow_back_ios_new_rounded),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _shiftWeek(7),
                  child: _buildCalArrow(isDark, Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Date row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final date = weekDates[index];
            final isSelected = _isSameDay(date, widget.selectedDate);
            return GestureDetector(
              onTap: () => widget.onDateSelected(date),
              child: isSelected
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.limeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            dayLabels[index],
                            style: GoogleFonts.outfit(
                              color: AppColors.limeDarkText,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString().padLeft(2, '0'),
                            style: GoogleFonts.outfit(
                              color: AppColors.limeDarkText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Text(
                            dayLabels[index],
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            date.day.toString().padLeft(2, '0'),
                            style: GoogleFonts.outfit(
                              color: isDark ? Colors.white70 : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCalArrow(bool isDark, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: 10,
        color: isDark ? Colors.white70 : AppColors.textPrimary,
      ),
    );
  }
}
