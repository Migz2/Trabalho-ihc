import 'package:flutter/material.dart';
import '../../domain/entities/timer_state_entity.dart';
import '../../../../core/theme/app_colors.dart';

/// Custom painter for the timer circle
class TimerPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final TimerPhase phase;
  final Brightness brightness;

  TimerPainter({
    required this.progress,
    required this.phase,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final isDark = brightness == Brightness.dark;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 10.0;

    // Get colors based on phase and brightness
    final trackColor = isDark ? AppColors.darkDivider : AppColors.lightDivider;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    Color progressColor;

    switch (phase) {
      case TimerPhase.focus:
        progressColor =
            isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
        break;
      case TimerPhase.shortBreak:
        progressColor =
            isDark ? AppColors.darkHygieneBar : AppColors.lightHygieneBar;
        break;
      case TimerPhase.longBreak:
        progressColor =
            isDark ? AppColors.darkAccent : AppColors.lightAccent;
        break;
    }

    // Draw track (background circle)
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // Draw progress arc with a primary->accent gradient
    const startAngle = -90 * 3.14159 / 180; // Start from top
    final sweepAngle = progress * 2 * 3.14159; // 360 degrees
    final arcRect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle.clamp(0.001, 2 * 3.14159),
        colors: [progressColor, accentColor],
      ).createShader(arcRect);

    canvas.drawArc(
      arcRect,
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.phase != phase ||
        oldDelegate.brightness != brightness;
  }
}
