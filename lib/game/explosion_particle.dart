import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ExplosionParticle extends PositionComponent {
  final Vector2 velocity;
  double life = 0.35;
  final Paint paintStyle;

  ExplosionParticle({
    required Vector2 position,
    required this.velocity,
    required this.paintStyle,
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
      3 * opacity,
      Paint()..color = paintStyle.color.withOpacity(opacity),
    );
  }

  static List<ExplosionParticle> burst(Vector2 center) {
    final rnd = Random();

    return List.generate(12, (_) {
      final angle = rnd.nextDouble() * pi * 2;
      final speed = 70 + rnd.nextDouble() * 120;

      return ExplosionParticle(
        position: center.clone(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        paintStyle: Paint()..color = const Color(0xFFFF5252),
      );
    });
  }
}