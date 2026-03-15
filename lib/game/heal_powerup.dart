import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealPowerup extends PositionComponent {
  HealPowerup({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(28),
        );

  Rect get hitbox => Rect.fromLTWH(
        position.x + 4,
        position.y + 4,
        20,
        20,
      );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final body = Paint()..color = const Color(0xFF66BB6A);
    final white = Paint()..color = Colors.white;

    canvas.drawCircle(const Offset(14, 14), 12, body);
    canvas.drawRect(const Rect.fromLTWH(12, 6, 4, 16), white);
    canvas.drawRect(const Rect.fromLTWH(6, 12, 16, 4), white);
  }
}