import 'package:flutter/cupertino.dart';

class BatteryIcon extends StatelessWidget {
  final int level; // 0–100
  final Color color;
  final double width;
  final double height;

  const BatteryIcon({
    super.key,
    required this.level,
    required this.color,
    this.width = 22,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _BatteryPainter(
        level: level,
        color: color,
      ),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  final int level;
  final Color color;

  _BatteryPainter({
    required this.level,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // ===== pin body =====
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width - 2, size.height),
      const Radius.circular(3),
    );

    canvas.drawRRect(bodyRect, stroke);

    // ===== pin head =====
    final headRect = Rect.fromLTWH(
      size.width - 2,
      size.height * 0.25,
      2,
      size.height * 0.5,
    );
    canvas.drawRect(headRect, fill);

    // ===== fill level =====
    final innerWidth = (size.width - 4) * (level.clamp(0, 100) / 100);

    final fillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, innerWidth, size.height - 2),
      const Radius.circular(2),
    );

    canvas.drawRRect(fillRect, fill);
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter oldDelegate) {
    return oldDelegate.level != level ||
        oldDelegate.color != color;
  }
}

