import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Patient extends PositionComponent {
  bool rescued = false;
  double pulseTime = 0;
  double fade = 1.0;

  Patient({required Vector2 position})
      : super(position: position, size: Vector2(60, 74));

  Rect get hitbox => Rect.fromLTWH(position.x + 8, position.y + 18, 44, 42);

  void heal() {
    rescued = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    pulseTime += dt;

    if (rescued) {
      fade -= dt * 1.5;
      if (fade <= 0) {
        removeFromParent();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    canvas.translate(0, sin(pulseTime * 5) * (rescued ? 1 : 2));

    final bed = Paint()..color = const Color(0xFFB3E5FC).withOpacity(fade);
    final pillow = Paint()..color = Colors.white.withOpacity(fade);
    final skin = Paint()..color = const Color(0xFFFFCC80).withOpacity(fade);
    final blanket = Paint()
      ..color = (rescued ? const Color(0xFF81C784) : const Color(0xFF90CAF9))
          .withOpacity(fade);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(4, 28, 52, 36),
        const Radius.circular(8),
      ),
      bed,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8, 24, 16, 10),
        const Radius.circular(4),
      ),
      pillow,
    );

    canvas.drawCircle(const Offset(18, 22), 8, skin);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(18, 30, 28, 18),
        const Radius.circular(6),
      ),
      blanket,
    );

    if (rescued) {
      final check = Paint()
        ..color = Colors.white.withOpacity(fade)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(
        const Offset(48, 12),
        8,
        Paint()..color = const Color(0xFF43A047).withOpacity(fade),
      );
      canvas.drawLine(const Offset(45, 12), const Offset(48, 15), check);
      canvas.drawLine(const Offset(48, 15), const Offset(53, 9), check);
    }

    canvas.restore();
  }
}