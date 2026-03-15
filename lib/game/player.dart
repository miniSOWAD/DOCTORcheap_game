import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  final double speed = 240;

  bool moveLeft = false;
  bool moveRight = false;
  bool moveUp = false;
  bool moveDown = false;

  int health = 5;
  int score = 0;
  int rescuedPatients = 0;
  bool carryingMedicine = false;

  Vector2 facing = Vector2(1, 0);

  Player() : super(position: Vector2(420, 320), size: Vector2(54, 72));

  Rect get hitbox => Rect.fromLTWH(position.x + 10, position.y + 6, 34, 58);

  Vector2 get centerPoint => Vector2(position.x + size.x / 2, position.y + size.y / 2);

  @override
  void update(double dt) {
    super.update(dt);

    Vector2 movement = Vector2.zero();

    if (moveLeft) movement.x -= 1;
    if (moveRight) movement.x += 1;
    if (moveUp) movement.y -= 1;
    if (moveDown) movement.y += 1;

    if (movement.length > 0) {
      movement.normalize();
      facing = movement.clone();
      position += movement * speed * dt;
    }

    position.x = position.x.clamp(0.0, 900 - size.x);
    position.y = position.y.clamp(120.0, 700 - size.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final coat = Paint()..color = Colors.white;
    final skin = Paint()..color = const Color(0xFFFFCC80);
    final blue = Paint()..color = const Color(0xFF1E88E5);
    final red = Paint()..color = const Color(0xFFE53935);
    final dark = Paint()..color = const Color(0xFF263238);

    canvas.drawOval(
      const Rect.fromLTWH(10, 62, 30, 8),
      Paint()..color = const Color(0x22000000),
    );

    canvas.drawCircle(const Offset(27, 12), 10, skin);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14, 24, 26, 24),
        const Radius.circular(6),
      ),
      coat,
    );

    canvas.drawRect(const Rect.fromLTWH(21, 26, 12, 20), blue);
    canvas.drawRect(const Rect.fromLTWH(25, 30, 4, 10), red);
    canvas.drawRect(const Rect.fromLTWH(22, 33, 10, 4), red);

    canvas.drawRect(const Rect.fromLTWH(8, 26, 6, 18), coat);
    canvas.drawRect(const Rect.fromLTWH(40, 26, 6, 18), coat);

    canvas.drawRect(const Rect.fromLTWH(18, 48, 6, 14), dark);
    canvas.drawRect(const Rect.fromLTWH(30, 48, 6, 14), dark);

    canvas.drawRect(const Rect.fromLTWH(16, 61, 10, 4), dark);
    canvas.drawRect(const Rect.fromLTWH(28, 61, 10, 4), dark);

    if (carryingMedicine) {
      final med = Paint()..color = const Color(0xFF43A047);
      final white = Paint()..color = Colors.white;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(40, 4, 10, 10),
          const Radius.circular(3),
        ),
        med,
      );
      canvas.drawRect(const Rect.fromLTWH(44, 5, 2, 8), white);
      canvas.drawRect(const Rect.fromLTWH(41, 8, 8, 2), white);
    }
  }
}