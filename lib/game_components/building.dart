import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:planet_city_builder/main.dart';

class Building extends PositionComponent{
  int capacity = 100;
  int population = 0;
  //int popIncrease = 0;
  Vector2 boxSize = Vector2(25,25);
  late Vector2 zonePos;
  final Random rng = Random();

  Paint paint = Paint()..color = Colors.black;

  Building(Vector2 position) {
    size = boxSize;
    anchor = Anchor.center;
    this.position = position;
    //print("Adding a building at position (${position.x}, ${position.y})");
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (rng.nextDouble() < 1.0 && population < capacity) {
      population++;
      //popIncrease++;
    }
  }
  /*
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), paint);
  }
  */
}