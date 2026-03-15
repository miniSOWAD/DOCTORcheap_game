import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Virus extends PositionComponent
    with CollisionCallbacks, HasGameRef<FlameGame> {
  final Random random = Random();
  final double speedMultiplier;

  late Vector2 velocity;
  double hitFlashTimer = 0;
  double spawnTimer = 0.28;

  Virus({
    required Vector2 position,
    required this.speedMultiplier,
  }) : super(
          position: position,
          size: Vector2(42, 42),
          scale: Vector2.zero(),
        );

  Rect get hitbox => Rect.fromLTWH(position.x + 6, position.y + 6, 30, 30);

  void triggerHitFlash() {
    hitFlashTimer = 0.15;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      CircleHitbox.relative(
        0.6,
        parentSize: size,
      ),
    );

    velocity = Vector2(
      (random.nextDouble() * 2 - 1) *
          (80 + random.nextDouble() * 40) *
          speedMultiplier,
      (random.nextDouble() * 2 - 1) *
          (80 + random.nextDouble() * 40) *
          speedMultiplier,
    );

    if (velocity.length == 0) {
      velocity = Vector2(100, 90);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // spawn animation
    if (spawnTimer > 0) {
      spawnTimer -= dt;
      final t = (1 - (spawnTimer / 0.28)).clamp(0.0, 1.0);
      scale = Vector2.all(t);
    } else {
      scale = Vector2.all(1);
    }

    // chase player when close
    final dynamic currentGame = gameRef;
    if (currentGame.player.parent != null) {
      final virusCenter = Vector2(
        position.x + size.x / 2,
        position.y + size.y / 2,
      );

      final toPlayer = currentGame.player.centerPoint - virusCenter;
      final distance = toPlayer.length;

      if (distance < 220 && distance > 0) {
        toPlayer.normalize();
        final chaseVelocity = toPlayer * (130 * speedMultiplier);
        velocity.lerp(chaseVelocity, 0.04);
      }
    }

    position += velocity * dt;

    // world bounds
    if (position.x <= 0 || position.x >= 900 - size.x) {
      velocity.x *= -1;
    }

    if (position.y <= 120 || position.y >= 700 - size.y) {
      velocity.y *= -1;
    }

    position.x = position.x.clamp(0.0, 900 - size.x);
    position.y = position.y.clamp(120.0, 700 - size.y);

    if (hitFlashTimer > 0) {
      hitFlashTimer -= dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final body = Paint()..color = const Color(0xFFD32F2F);
    final dark = Paint()..color = const Color(0xFF8E0000);

    if (hitFlashTimer > 0) {
      canvas.drawCircle(
        const Offset(21, 21),
        20,
        Paint()..color = const Color(0x55FF5252),
      );
    }

    canvas.drawCircle(const Offset(21, 21), 14, body);

    const spikes = [
      Offset(21, 2),
      Offset(34, 7),
      Offset(39, 21),
      Offset(34, 34),
      Offset(21, 39),
      Offset(8, 34),
      Offset(3, 21),
      Offset(8, 8),
    ];

    for (final s in spikes) {
      canvas.drawCircle(s, 4, body);
    }

    canvas.drawCircle(const Offset(16, 17), 2.5, dark);
    canvas.drawCircle(const Offset(26, 17), 2.5, dark);

    final mouthPaint = Paint()
      ..color = const Color(0xFF8E0000)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      const Rect.fromLTWH(14, 19, 14, 8),
      0.2,
      2.6,
      false,
      mouthPaint,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // bounce on blockers / furniture / other solid things
    final otherName = other.runtimeType.toString();

    if (otherName == 'FurnitureBlock') {
      velocity = -velocity;
      position += velocity.normalized() * 6;
    }
  }
}