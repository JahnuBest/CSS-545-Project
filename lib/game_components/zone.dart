import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planet_city_builder/game_components/building.dart';
import 'package:planet_city_builder/game_components/zone_info_component.dart';

enum ZoneType { research, residential, recreation, mining }

class Zone extends PositionComponent with TapCallbacks {
  late ZoneType type;
  late TextComponent zoneInfo;
  List<Building> buildings = [];
  List<Vector2> zoneSlots = [];
  bool active = false;
  bool visible = false;
  
  //late ZoneInfoComponent zic;
  Map<String, int> resources = {
    "Iron":0,
    "Oil":0,
    "Uranium":0
  };
  double cost = 1000000;

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

    resources["Iron"] = rng.nextInt(10);
    resources["Oil"] = rng.nextInt(50);
    resources["Uranium"] = rng.nextInt(5);

    //Flat cost of new zone: $1,000,000
    //Iron: 10,000  Oil: 5,000  Uranium: 50,000
    cost += (resources["Iron"]! * 10000) + (resources["Oil"]! * 5000) + (resources["Uranium"]! * 50000);
    
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
    //zic = ZoneInfoComponent(position);
  }

  @override
  Future<void> onLoad() async {
    String zoneInfoText = "";
    resources.forEach((k,v) => zoneInfoText += "$k: $v\n");
    zoneInfoText += "\$${NumberFormat.decimalPattern().format(cost)}";
    zoneInfo = TextComponent(
      text: zoneInfoText,
          textRenderer: TextPaint(
            style: const TextStyle(
            fontSize: 12,
            fontFamily: "Cartesian",
            color: Colors.white,
            ),
          ),
          position: Vector2(position.x + 50, position.y + 50),
    );
    //add(zoneInfo);
  }

  late TextComponent _zoneCount;

  Color _getBaseColor(ZoneType type) {
    switch (type) {
      case ZoneType.residential:
        return Colors.green;
      case ZoneType.research:
        return Colors.blue;
      case ZoneType.mining:
        return Colors.yellow;
      case ZoneType.recreation:
        return Colors.purple;
    }
  }
  
  //demand.clamp(0.2, 1.0)
  Color get zoneColor => baseColor.withOpacity(0.5);
  Paint get zonePaint => Paint()..color = zoneColor;
  Paint get zoneBorder => Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

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
  void onTapUp(TapUpEvent event) {
    if (!active) {
      active = true;
      remove(zoneInfo);
    }
    /*
    if (zic.parent == this) {
      remove(zic);
    }
    else {
      add(zic);
    }
    */
    //print("Pressed zone");
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _zoneCount.position = position + Vector2(width / 2, height / 2);  
  }

  @override
  void render(Canvas canvas) {
    if (visible) {
      if (active) {
        canvas.drawRect(size.toRect(), zonePaint);
        _zoneCount.render(canvas);
      }
      else {
        canvas.drawRect(size.toRect(), zoneBorder);
        zoneInfo.render(canvas);
      }
    }
    
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