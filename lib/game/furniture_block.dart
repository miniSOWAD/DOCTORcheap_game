import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FurnitureBlock extends PositionComponent {
  FurnitureBlock({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  Rect get hitbox => Rect.fromLTWH(
        position.x,
        position.y,
        size.x,
        size.y,
      );
}