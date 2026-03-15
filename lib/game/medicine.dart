import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Medicine extends PositionComponent {
  Medicine({required Vector2 position})
      : super(position: position, size: Vector2(26, 26));

  Rect get hitbox => Rect.fromLTWH(position.x + 3, position.y + 3, 20, 20);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final green = Paint()..color = const Color(0xFF43A047);
    final white = Paint()..color = Colors.white;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 2, 22, 22),
        const Radius.circular(6),
      ),
      green,
    );

    canvas.drawRect(const Rect.fromLTWH(11, 5, 4, 14), white);
    canvas.drawRect(const Rect.fromLTWH(6, 10, 14, 4), white);
  }
}