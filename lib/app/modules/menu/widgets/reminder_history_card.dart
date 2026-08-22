import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class ReminderHistoryCard extends StatelessWidget {
  final bool isDark;
  final Map<String, dynamic> log;

  const ReminderHistoryCard({super.key, required this.isDark, required this.log});

  @override
  Widget build(BuildContext context) {
    final type = log['type'] ?? 'medicine';
    final name = log['name'] ?? 'Reminder';
    final action = log['action'] ?? 'triggered';
    final details = log['details'] ?? '';

    DateTime timestamp = DateTime.now();
    if (log['timestamp'] != null) {
      timestamp = DateTime.tryParse(log['timestamp']) ?? DateTime.now();
    }
    final timeStr = DateFormat('hh:mm a').format(timestamp);
    final dateStr = DateFormat('dd MMMM').format(timestamp);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getActionColor(action).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTypeIcon(type, action),
              color: _getActionColor(action),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '$dateStr, $timeStr',
                      style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        details,
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getActionColor(action).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        action.toString().replaceAll('_', ' ').toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: _getActionColor(action),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type, String action) {
    if (type == 'water') {
      return Icons.opacity_rounded;
    }
    switch (action) {
      case 'taken':
        return Icons.check_circle_rounded;
      case 'skipped':
        return Icons.cancel_rounded;
      case 'missed':
        return Icons.hourglass_disabled_rounded;
      case 'snoozed':
        return Icons.snooze_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'taken':
      case 'water_logged':
        return Colors.green;
      case 'skipped':
        return Colors.redAccent;
      case 'missed':
        return Colors.orangeAccent;
      case 'snoozed':
        return Colors.amber;
      default:
        return Colors.blueAccent;
    }
  }
}
