import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// CalendarWidget — full calendar display.
class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime, DateTime)? onDaySelected;
  final CalendarFormat calendarFormat;
  final void Function(CalendarFormat)? onFormatChanged;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    this.onDaySelected,
    this.calendarFormat = CalendarFormat.month,
    this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.paddingSmall),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        calendarFormat: calendarFormat,
        onFormatChanged: onFormatChanged,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
            fontSize: AppSizes.fontSmall,
          ),
          weekendTextStyle: TextStyle(
            color: AppColors.error,
            fontSize: AppSizes.fontSmall,
          ),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: onFormatChanged != null,
          titleTextStyle: TextStyle(
            fontSize: AppSizes.fontMedium,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.primary,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
