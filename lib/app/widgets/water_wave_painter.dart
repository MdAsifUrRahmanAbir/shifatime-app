import 'dart:math';
import 'package:flutter/material.dart';

class WaterWavePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final double animationValue; // 0.0 to 1.0 for wave motion
  final Color waveColor;

  WaterWavePainter({
    required this.progress,
    required this.animationValue,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Calculate current fill line (0.0 progress = height, 1.0 progress = 0.0)
    final double fillLevel = height * (1 - progress.clamp(0.0, 1.0));

    // First Wave (Background wave - slightly lighter/lower opacity)
    final Paint paint1 = Paint()
      ..color = waveColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final Path path1 = Path();
    path1.moveTo(0, fillLevel);

    for (double x = 0; x <= width; x++) {
      // Wave equation: y = sin(x * frequency + phase) * amplitude + verticalOffset
      final double relativeX = x / width;
      final double y = sin((relativeX * 2 * pi) + (animationValue * 2 * pi)) * 8 + fillLevel;
      path1.lineTo(x, y.clamp(0.0, height));
    }
    path1.lineTo(width, height);
    path1.lineTo(0, height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Second Wave (Foreground wave - solid and offset)
    final Paint paint2 = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final Path path2 = Path();
    path2.moveTo(0, fillLevel);

    for (double x = 0; x <= width; x++) {
      final double relativeX = x / width;
      // Offset the phase by pi/2 to separate the wave shapes
      final double y = cos((relativeX * 2 * pi) - (animationValue * 2 * pi)) * 10 + fillLevel;
      path2.lineTo(x, y.clamp(0.0, height));
    }
    path2.lineTo(width, height);
    path2.lineTo(0, height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant WaterWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.waveColor != waveColor;
  }
}
