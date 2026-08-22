import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../widgets/reminder_history_card.dart';
import '../widgets/clear_history_dialog.dart';

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
            onPressed: () => showClearHistoryDialog(logBox),
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: ValueListenableBuilder(
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
                return ReminderHistoryCard(isDark: isDark, log: log);
              },
            );
          },
        ),
      ),
    );
  }
}
