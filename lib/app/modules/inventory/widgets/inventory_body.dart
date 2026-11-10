import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/health_analytics.dart';
import '../../../data/models/medicine_model.dart';
import '../../../widgets/health_widgets.dart';
import '../../medicine/controllers/medicine_controller.dart';
import 'inventory_medicine_card.dart';

/// Stock state of one medicine, used for sorting and the summary row.
enum StockState { out, low, ok, untracked, paused }

StockState stockStateOf(Medicine m) {
  if (!(m.isActive ?? false)) return StockState.paused;
  if (m.totalStock == null) return StockState.untracked;
  if (m.totalStock! <= 0) return StockState.out;
  final days = HealthAnalytics.daysOfStockLeft(m);
  if (m.totalStock! <= (m.stockThreshold ?? 5) || (days != null && days <= 3)) return StockState.low;
  return StockState.ok;
}

class InventoryBody extends GetView<MedicineController> {
  const InventoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final list = [...controller.medicines]
        ..sort((a, b) {
          final s = stockStateOf(a).index.compareTo(stockStateOf(b).index);
          if (s != 0) return s;
          return (HealthAnalytics.daysOfStockLeft(a) ?? 9999).compareTo(HealthAnalytics.daysOfStockLeft(b) ?? 9999);
        });

      if (list.isEmpty) {
        return const Center(
          child: HealthEmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'No medicines yet',
            subtitle: 'Add a medicine with its stock count to\ntrack how many days it will last.',
          ),
        );
      }

      final states = list.map(stockStateOf).toList();
      final tracked = states.where((s) => s == StockState.ok || s == StockState.low || s == StockState.out).length;
      final low = states.where((s) => s == StockState.low).length;
      final out = states.where((s) => s == StockState.out).length;

      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          HealthCard(
            child: Row(
              children: [
                Expanded(child: StatTile(label: 'Tracked', value: '$tracked', caption: 'of ${list.length} medicines')),
                Expanded(
                  child: StatTile(
                    label: 'Running low',
                    value: '$low',
                    caption: '3 days or below alert',
                    valueColor: low > 0 ? AppColors.warning : AppColors.primary,
                  ),
                ),
                Expanded(
                  child: StatTile(
                    label: 'Out of stock',
                    value: '$out',
                    caption: out > 0 ? 'refill now' : 'all good',
                    valueColor: out > 0 ? AppColors.error : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final m in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InventoryMedicineCard(medicine: m, isDark: isDark, state: stockStateOf(m)),
            ),
        ],
      );
    });
  }
}
