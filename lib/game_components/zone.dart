import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum ZoneType { residential, commercial, industrial }

class Zone extends PositionComponent {
  final ZoneType type;

  Zone({required this.type, required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final color = _getZoneColor(type);
    final paint = Paint()..color = color;
    canvas.drawRect(size.toRect(), paint);
  }

  Color _getZoneColor(ZoneType type) {
    switch (type) {
      case ZoneType.residential:
        return Colors.green;
      case ZoneType.commercial:
        return Colors.blue;
      case ZoneType.industrial:
        return Colors.yellow;
    }
  }

  bool isOverlapping(Vector2 otherPosition, Vector2 otherSize) {
    return position.x < otherPosition.x + otherSize.x &&
           position.x + size.x > otherPosition.x &&
           position.y < otherPosition.y + otherSize.y &&
           position.y + size.y > otherPosition.y;
  }
}