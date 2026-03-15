import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealingParticle extends PositionComponent {
  final Vector2 velocity;
  double life = 0.5;

  HealingParticle({
    required Vector2 position,
    required this.velocity,
  }) : super(
          position: position,
          size: Vector2.all(6),
        );

  @override
  void update(double dt) {
    super.update(dt);
    life -= dt;
    position += velocity * dt;

    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final opacity = life.clamp(0.0, 1.0);
    canvas.drawCircle(
      const Offset(3, 3),
      3,
      Paint()..color = const Color(0xFF80CBC4).withOpacity(opacity),
    );
  }

  static List<HealingParticle> around(Vector2 center) {
    final rnd = Random();

    return List.generate(12, (_) {
      final angle = rnd.nextDouble() * pi * 2;
      final speed = 30 + rnd.nextDouble() * 60;

      return HealingParticle(
        position: center.clone(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
      );
    });
  }
}