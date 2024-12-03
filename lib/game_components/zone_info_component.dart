import 'package:flutter/material.dart' hide Route;
import 'package:flame/components.dart';

class ZoneInfoComponent extends PositionComponent {
  
  ZoneInfoComponent(this.pos);

  Map<String, int> resources = {
        "Iron":2, "Oil": 24, "Uranium":5
      };
  double cost = 1234567;
  Vector2 pos;

  @override
  Future<void> onLoad() async {
    //Change later
    resources.forEach((k,v) => 
      add(
        TextComponent(
          text: "$k: $v",
          textRenderer: TextPaint(
            style: const TextStyle(
            fontSize: 12,
            fontFamily: "Cartesian",
            color: Colors.black,
            ),
          ),
          position: pos,
        )
      ));
      pos.y += 20;
      /*
      add(
        TextComponent(
          text
        )
      )
      */
    }
}