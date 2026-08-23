import 'package:flutter/material.dart';

/// Draws a trend line through [values] (e.g. the last 7 days of water
/// intake), normalized to the tallest value, with a dot marking the last
/// (most recent) point.
class SparklinePainter extends CustomPainter {
  final bool isDark;
  final List<double> values;
  SparklinePainter({required this.isDark, required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final safeMax = maxVal <= 0 ? 1.0 : maxVal;
    final stepX = values.length > 1 ? size.width / (values.length - 1) : size.width;

    final paint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = size.height - (values[i] / safeMax) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    final lastX = stepX * (values.length - 1);
    final lastY = size.height - (values.last / safeMax) * size.height;
    final dotPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(lastX, lastY), 3.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) =>
      oldDelegate.values != values;
}
