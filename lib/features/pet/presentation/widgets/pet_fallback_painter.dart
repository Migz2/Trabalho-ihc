import 'package:flutter/material.dart';
import '../../domain/entities/pet_mood_enum.dart';

/// Draws a simple puppy in pure Flutter shapes, used whenever the real pet
/// artwork (PNG) is missing on disk so Mel never renders as a broken image.
class PetFallbackPainter extends CustomPainter {
  final PetMood mood;

  const PetFallbackPainter({required this.mood});

  bool get _isHappy => mood == PetMood.happy || mood == PetMood.ecstatic;
  bool get _isSad => mood == PetMood.sad || mood == PetMood.neglected;

  @override
  void paint(Canvas canvas, Size size) {
    // Reference design box is 160x160; scale to whatever size is requested.
    final scale = size.width / 160;
    canvas.save();
    canvas.scale(scale, scale);

    const center = Offset(80, 90);

    final bodyPaint = Paint()..color = const Color(0xFFE8C99A);
    final earPaint = Paint()..color = const Color(0xFFC4956A);
    final eyePaint = Paint()..color = const Color(0xFF4A3324);
    final nosePaint = Paint()..color = const Color(0xFF4A3324);
    final mouthPaint = Paint()
      ..color = const Color(0xFF4A3324)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final tailPaint = Paint()
      ..color = const Color(0xFFE8C99A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Tail
    final tailPath = Path()
      ..moveTo(center.dx + 38, center.dy + 10)
      ..quadraticBezierTo(
        center.dx + 60, center.dy - 10,
        center.dx + 50, center.dy - 35,
      );
    canvas.drawPath(tailPath, tailPaint);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 15), width: 80, height: 70),
      bodyPaint,
    );

    // Head
    final headCenter = Offset(center.dx, center.dy - 30);
    canvas.drawCircle(headCenter, 36, bodyPaint);

    // Ears
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(headCenter.dx - 28, headCenter.dy - 18),
        width: 18,
        height: 30,
      ),
      earPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(headCenter.dx + 28, headCenter.dy - 18),
        width: 18,
        height: 30,
      ),
      earPaint,
    );

    // Eyes
    final eyeY = headCenter.dy - 2;
    if (_isSad) {
      // Semi-closed: short horizontal arcs
      _drawArc(canvas, Offset(headCenter.dx - 13, eyeY), 7, eyePaint);
      _drawArc(canvas, Offset(headCenter.dx + 13, eyeY), 7, eyePaint);
    } else if (_isHappy) {
      // Happy: upward curved closed eyes
      _drawSmileEye(canvas, Offset(headCenter.dx - 13, eyeY), eyePaint);
      _drawSmileEye(canvas, Offset(headCenter.dx + 13, eyeY), eyePaint);
    } else {
      canvas.drawCircle(Offset(headCenter.dx - 13, eyeY), 4, eyePaint);
      canvas.drawCircle(Offset(headCenter.dx + 13, eyeY), 4, eyePaint);
    }

    // Nose
    canvas.drawOval(
      Rect.fromCenter(center: Offset(headCenter.dx, headCenter.dy + 14), width: 10, height: 7),
      nosePaint,
    );

    // Mouth
    final mouthPath = Path();
    final mouthCenter = Offset(headCenter.dx, headCenter.dy + 18);
    if (_isHappy) {
      mouthPath.moveTo(mouthCenter.dx - 14, mouthCenter.dy);
      mouthPath.quadraticBezierTo(
        mouthCenter.dx, mouthCenter.dy + 14,
        mouthCenter.dx + 14, mouthCenter.dy,
      );
    } else if (_isSad) {
      mouthPath.moveTo(mouthCenter.dx - 10, mouthCenter.dy + 6);
      mouthPath.quadraticBezierTo(
        mouthCenter.dx, mouthCenter.dy - 4,
        mouthCenter.dx + 10, mouthCenter.dy + 6,
      );
    } else {
      mouthPath.moveTo(mouthCenter.dx - 8, mouthCenter.dy);
      mouthPath.quadraticBezierTo(
        mouthCenter.dx, mouthCenter.dy + 6,
        mouthCenter.dx + 8, mouthCenter.dy,
      );
    }
    canvas.drawPath(mouthPath, mouthPaint);

    canvas.restore();
  }

  void _drawArc(Canvas canvas, Offset center, double radius, Paint paint) {
    final arcPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 2),
      0.15,
      2.85,
      false,
      arcPaint,
    );
  }

  void _drawSmileEye(Canvas canvas, Offset center, Paint paint) {
    final eyePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(center.dx - 6, center.dy + 2)
      ..quadraticBezierTo(center.dx, center.dy - 6, center.dx + 6, center.dy + 2);
    canvas.drawPath(path, eyePaint);
  }

  @override
  bool shouldRepaint(covariant PetFallbackPainter oldDelegate) =>
      oldDelegate.mood != mood;
}
