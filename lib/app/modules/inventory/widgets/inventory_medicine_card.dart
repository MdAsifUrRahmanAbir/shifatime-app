import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_snackbar.dart';
import '../../../core/services/health_analytics.dart';
import '../../../data/models/medicine_model.dart';
import '../../../widgets/health_widgets.dart';
import '../../medicine/controllers/medicine_controller.dart';
import 'inventory_body.dart';

class InventoryMedicineCard extends GetView<MedicineController> {
  final Medicine medicine;
  final bool isDark;
  final StockState state;

  const InventoryMedicineCard({super.key, required this.medicine, required this.isDark, required this.state});

  HealthStatus get _status {
    switch (state) {
      case StockState.out:
        return const HealthStatus('Out of stock', HealthLevel.critical);
      case StockState.low:
        return const HealthStatus('Running low', HealthLevel.elevated);
      case StockState.ok:
        return const HealthStatus('In stock', HealthLevel.normal);
      case StockState.untracked:
        return const HealthStatus('Not tracked', HealthLevel.unknown);
      case StockState.paused:
        return const HealthStatus('Paused', HealthLevel.unknown);
    }
  }

  String get _unitWord {
    switch (medicine.type) {
      case 'Tablet':
        return 'tablets';
      case 'Capsule':
        return 'capsules';
      case 'Injection':
        return 'doses';
      case 'Syrup':
        return 'doses';
      default:
        return 'units';
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final tracked = medicine.totalStock != null;
    final perDay = HealthAnalytics.dailyUsage(medicine);
    final days = HealthAnalytics.daysOfStockLeft(medicine);
    final runOut = days == null ? null : DateTime.now().add(Duration(days: days));
    final threshold = medicine.stockThreshold ?? 5;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    // Progress against a 30-day supply, so the bar reads like "how full is the box".
    final monthSupply = perDay > 0 ? perDay * 30 : (threshold * 4).toDouble();
    final fill = tracked ? (medicine.totalStock! / monthSupply).clamp(0.0, 1.0) : 0.0;

    return Opacity(
      opacity: state == StockState.paused ? 0.6 : 1,
      child: HealthCard(
        borderColor: status.isAbnormal ? status.color.withValues(alpha: 0.35) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine.name ?? 'Medicine',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 2),
                      Text(
                        '${medicine.type ?? ''} • ${medicine.customDosage ?? '${medicine.dosage ?? 1} per dose'}'
                        '${perDay > 0 ? ' • ${_fmt(perDay)}/day' : ''}',
                        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                StatusPill(status, fontSize: 11),
              ],
            ),
            if (tracked) ...[
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${medicine.totalStock}',
                      style: GoogleFonts.outfit(
                          fontSize: 24, fontWeight: FontWeight.bold, color: status.isAbnormal ? status.color : textColor)),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('$_unitWord left', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                  ),
                  const Spacer(),
                  if (days != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(days == 0 ? 'Runs out today' : '~$days day${days == 1 ? '' : 's'} left',
                            style: GoogleFonts.outfit(
                                fontSize: 13, fontWeight: FontWeight.bold, color: status.isAbnormal ? status.color : textColor)),
                        if (runOut != null && days > 0)
                          Text('until ${DateFormat('dd MMM').format(runOut)}',
                              style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: fill,
                  minHeight: 7,
                  backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation(status.isAbnormal ? status.color : AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text('Alert when $threshold or fewer left',
                  style: GoogleFonts.outfit(fontSize: 10.5, color: Colors.grey)),
              const Divider(height: 22),
              Row(
                children: [
                  Text('Refill', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                  const Spacer(),
                  _refillButton('+10', () => _addStock(10)),
                  const SizedBox(width: 6),
                  _refillButton('+30', () => _addStock(30)),
                  const SizedBox(width: 6),
                  _refillButton('Edit', () => _showStockDialog(context), icon: Icons.edit_rounded),
                ],
              ),
            ] else if (state != StockState.paused) ...[
              const SizedBox(height: 12),
              Text('Enter how many you have to see how long it will last.',
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 10),
              _refillButton('Start tracking stock', () => _showStockDialog(context), icon: Icons.add_rounded),
            ],
          ],
        ),
      ),
    );
  }

  static String _fmt(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  Future<void> _addStock(int amount) async {
    medicine.totalStock = (medicine.totalStock ?? 0) + amount;
    medicine.isStockAlertEnabled = true;
    await medicine.save();
    controller.medicines.refresh();
    AppSnackBar.success('${medicine.name}: +$amount added (${medicine.totalStock} now)');
  }

  void _showStockDialog(BuildContext context) {
    final stockCtrl = TextEditingController(text: medicine.totalStock?.toString() ?? '');
    final thresholdCtrl = TextEditingController(text: (medicine.stockThreshold ?? 5).toString());

    Widget field(String label, TextEditingController c) => TextField(
          controller: c,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.outfit(),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.outfit(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(medicine.name ?? 'Stock', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            field('Current stock ($_unitWord)', stockCtrl),
            const SizedBox(height: 12),
            field('Alert me at', thresholdCtrl),
          ],
        ),
        actions: [
          if (medicine.totalStock != null)
            TextButton(
              onPressed: () async {
                medicine.totalStock = null;
                medicine.isStockAlertEnabled = false;
                await medicine.save();
                controller.medicines.refresh();
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text('Stop tracking', style: GoogleFonts.outfit(color: AppColors.error)),
            ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.outfit())),
          TextButton(
            onPressed: () async {
              final stock = int.tryParse(stockCtrl.text.trim());
              if (stock == null) return;
              medicine.totalStock = stock;
              medicine.stockThreshold = int.tryParse(thresholdCtrl.text.trim()) ?? 5;
              medicine.isStockAlertEnabled = true;
              await medicine.save();
              controller.medicines.refresh();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text('Save', style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _refillButton(String label, VoidCallback onTap, {IconData? icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: AppColors.primary), const SizedBox(width: 4)],
            Text(label,
                style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
