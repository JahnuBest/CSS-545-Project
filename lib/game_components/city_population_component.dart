import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CityPopulationComponent extends TextComponent {
  CityPopulationComponent({int initialPopulation = 0})
      : population = initialPopulation,
        super(
          text: 'Population: $initialPopulation',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "GameOfSquids",
              color: Colors.black54,
            ),
          ),
          anchor: Anchor.center,
        );

  int population;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, size.y - 50);  
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (text != 'Population: $population') {
      text = 'Population: $population';
    }
  }
}