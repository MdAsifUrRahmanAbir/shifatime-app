import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class ReminderHistoryView extends StatefulWidget {
  const ReminderHistoryView({super.key});

  @override
  State<ReminderHistoryView> createState() => _ReminderHistoryViewState();
}

class _ReminderHistoryViewState extends State<ReminderHistoryView> {
  late final Box logBox;

  @override
  void initState() {
    super.initState();
    logBox = Hive.box('activity_logs');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Reminder History',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_rounded, color: Colors.redAccent.withValues(alpha: 0.8)),
            tooltip: 'Clear History',
            onPressed: _showClearDialog,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: logBox.listenable(),
        builder: (context, Box box, _) {
          final rawLogs = box.values.toList().reversed.toList();
          
          if (rawLogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No reminder logs recorded yet',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your medicine and water progress will appear here.',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: rawLogs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final log = Map<String, dynamic>.from(rawLogs[index] as Map);
              return _buildHistoryCard(isDark, log);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(bool isDark, Map<String, dynamic> log) {
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
          // Left Status Indicator (Timeline indicator colored)
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

          // Center: Log Text details
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
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
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
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getActionColor(action).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        action.replaceAll('_', ' ').toUpperCase(),
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

  void _showClearDialog() {
    Get.defaultDialog(
      title: 'Clear History',
      titleStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
      middleText: 'Are you sure you want to delete all activity and notification logs?',
      middleTextStyle: GoogleFonts.outfit(),
      textConfirm: 'Clear All',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        logBox.clear();
        Get.back();
        Get.snackbar(
          'History Cleared 🧹',
          'Successfully deleted history log records.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
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
