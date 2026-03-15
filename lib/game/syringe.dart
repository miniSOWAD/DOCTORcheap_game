import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Syringe extends PositionComponent {
  final Vector2 direction;
  final double speed = 420;

  Syringe({
    required Vector2 position,
    required this.direction,
  }) : super(position: position, size: Vector2(26, 10));

  Rect get hitbox => Rect.fromLTWH(position.x, position.y, 20, 6);

  @override
  void update(double dt) {
    super.update(dt);

    position += direction * speed * dt;

    if (position.x < -40 ||
        position.x > 940 ||
        position.y < -40 ||
        position.y > 740) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();

    final angle = direction.screenAngle();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(angle);
    canvas.translate(-size.x / 2, -size.y / 2);

    final white = Paint()..color = Colors.white;
    final blue = Paint()..color = const Color(0xFF42A5F5);
    final grey = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 2, 14, 6),
        const Radius.circular(2),
      ),
      white,
    );

    canvas.drawRect(const Rect.fromLTWH(6, 3, 6, 4), blue);
    canvas.drawRect(const Rect.fromLTWH(0, 3, 3, 4), Paint()..color = const Color(0xFFCFD8DC));
    canvas.drawLine(const Offset(16, 5), const Offset(25, 5), grey);

    canvas.restore();
  }
}