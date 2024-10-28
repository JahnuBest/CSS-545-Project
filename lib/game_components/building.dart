import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Building extends PositionComponent {
  Building(Vector2 position) {
    this.position = position;
    size = Vector2(25, 25); // Size of the building
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.black; // Building color
    canvas.drawRect(size.toRect(), paint);
  }
}