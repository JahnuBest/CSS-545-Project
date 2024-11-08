import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:planet_city_builder/game_components/building.dart';

enum ZoneType { residential, commercial, industrial }

class Zone extends PositionComponent with DragCallbacks{
  late ZoneType type;
  List<Building> buildings = [];
  List<Vector2> zoneSlots = [];
  
  //double demand = 0.0;
  final Random rng = Random();
  late Color baseColor;
  late Paint paint;

  //Zone({required this.type, required Vector2 position, required Vector2 size}) : super(position: position, size: size);
  Zone(ZoneType zonetype, Vector2 position, Vector2 size){
    type = zonetype;
    this.position = position;
    this.size = size;
    baseColor = _getBaseColor(type);
    paint = Paint()..color = baseColor;
    const double margin = 12.5;
    zoneSlots = [
      position + Vector2(margin, margin),                      
      position + Vector2(size.x - 25 - margin, margin),             
      position + Vector2(margin, size.y - 25 - margin),             
      position + Vector2(size.x - 25 - margin, size.y - 25 - margin)
    ];
    _zoneCount = TextComponent(
      text: '0',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'arial'
        )
      ),
      anchor: Anchor.center,
    );
  }

  late TextComponent _zoneCount;

  Color _getBaseColor(ZoneType type) {
    switch (type) {
      case ZoneType.residential:
        return Colors.green;
      case ZoneType.commercial:
        return Colors.blue;
      case ZoneType.industrial:
        return Colors.yellow;
    }
  }
  
  //demand.clamp(0.2, 1.0)
  Color get zoneColor => baseColor.withOpacity(0.5);
  Paint get zonePaint => Paint()..color = zoneColor;

  void generateBuildings() {
    buildings.add(Building(zoneSlots.removeAt(rng.nextInt(zoneSlots.length))));
    //demand = 0.01;
    _zoneCount.text = buildings.length.toString();
    //print("There are now ${buildings.length} buildings in the $type zone and ${zoneSlots.length} zone slots left");
  }

/*
  Vector2 getNextBuildingPosition(Vector2 size) {
    int slot = rng.nextInt(zoneSlots.length);
    double x = zoneSlots[slot].x;
    double y = zoneSlots[slot].y;
    zoneSlots.removeAt(slot);
    return Vector2(x, y);
  }
*/

  bool isOverlapping(Vector2 otherPosition, Vector2 otherSize) {
    return position.x < otherPosition.x + otherSize.x &&
           position.x + size.x > otherPosition.x &&
           position.y < otherPosition.y + otherSize.y &&
           position.y + size.y > otherPosition.y;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _zoneCount.position = position + Vector2(width / 2, height / 2);  
  }

   @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), zonePaint);
    _zoneCount.render(canvas);
    /*
    for (final building in buildings) {
      building.render(canvas);
    }
    */
  }
/*
  @override
  void update(double dt) {
    super.update(dt);
    if (zoneSlots.isNotEmpty) {
      demand += rng.nextDouble() * dt * 0.002;
      demand = demand.clamp(0.0, 1.0);
      if (rng.nextDouble() < demand) generateBuildings();
    } else {
      if (demand != 0.0) {
       demand = 0.0;
      }
    }
  }
  */
}