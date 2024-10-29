import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:planet_city_builder/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/gestures.dart';

class PlanetSelectScreen extends Component with HasGameRef<PlanetCityBuilder> {
  int currentPlanetIndex = 0;
  List<Planet> planets = [];
  late Vector2 centerPosition; // Centered position for focused planet
  Offset offset = Offset.zero;

  PlanetSelectScreen() : centerPosition = Vector2(300, 400);
  
  //centerPosition = Vector2(gameRef.size.x / 2, gameRef.size.y); 

  @override
  Future<void> onLoad() async {
    planets = [
      Planet(imagePath: 'mars_planet.png', position: Vector2(100, centerPosition.y)),
      Planet(imagePath: 'ice_planet.png', position: Vector2(500, centerPosition.y)),
      Planet(imagePath: 'fire_planet.png', position: Vector2(900, centerPosition.y)),
    ];

    for (var planet in planets) {
      await add(planet);
    }
    _updateFocus();
/*
    gameRef.add(GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! < 0) {
          onSwipeLeft();
        } else if (details.primaryDelta! > 0) {
          onSwipeRight();
        }
      },
      onTap: () {
        if (planets[currentPlanetIndex].isFocused) {
          onPlanetTap();
        }
      },
      child: this, // Wraps PlanetSelectScreen with gesture handling
    ));
  */
  }

  void onSwipeLeft() {
    if (currentPlanetIndex < planets.length - 1) {
      currentPlanetIndex++;
      _updateFocus();
    }
  }

  void onSwipeRight() {
    if (currentPlanetIndex > 0) {
      currentPlanetIndex--;
      _updateFocus();
    }
  }

  void _updateFocus() {
    for (var i = 0; i < planets.length; i++) {
      planets[i].isFocused = (i == currentPlanetIndex);
      planets[i].position = centerPosition + Vector2((i - currentPlanetIndex) * 400, 0);
    }
  }

  void onPlanetTap() {
    gameRef.router.pushNamed('maingame');
  }

  @override
  void render (Canvas canvas ){
    final paint = Paint()..color = Colors.black;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      paint,
    );

    for (final planet in planets) {
      final centerX = gameRef.size.x / 2 + offset.dx + planets.indexOf(planet) * gameRef.size.x;
      planet.render(canvas);
    }
  }
  
}

class Planet extends PositionComponent with HasGameRef<PlanetCityBuilder>{
  final String imagePath;
  late Sprite sprite;
  bool isFocused = false;

  Planet({required this.imagePath, required Vector2 position}) {
    this.position = position;
    //print(position);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(imagePath);
  }
/*
  @override
  void render(Canvas canvas) {
    final targetHeight = gameRef.size.y / 2;
  
    final scale = isFocused ? (targetHeight / sprite.srcSize.y) * 1.2 : targetHeight / sprite.srcSize.y;
    final scaledSize = Vector2(sprite.srcSize.x * scale, targetHeight / sprite.srcSize.y);

    final offsetPosition = offset + Offset(scaledSize.x / 2, scaledSize.y / 2);

    // Draw the scaled sprite at the centered position
    sprite.render(
      canvas,
      Rect.fromCenter(center: center, width: width, height: height)
      center: Vector2(offsetPosition),
      size: scaledSize,
      //Rect.fromLTWH(offsetPosition.dx, offsetPosition.dy, scaledSize.x, scaledSize.y),
    );
  }
  */
}

// Wrap PlanetSelectScreen with GestureDetector in your game widget to handle gestures

