import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:planet_city_builder/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/gestures.dart';

class PlanetSelectScreen extends Component with HasGameRef<PlanetCityBuilder> {
  int currentPlanetIndex = 0;
  late SpriteComponent background;
  List<SpriteComponent> planets = [];
  late Vector2 centerPosition; // Centered position for focused planet
  Offset offset = Offset.zero;

  //PlanetSelectScreen() : centerPosition = Vector2(300, 400);
  
  //centerPosition = Vector2(gameRef.size.x / 2, gameRef.size.y); 

  @override
  Future<void> onLoad() async {
    centerPosition = gameRef.size / 2;
    background = SpriteComponent()
      ..sprite = await Sprite.load('stars.jpg');

    background.size = calcSpriteSize(background.sprite!.originalSize, 1);
    background.anchor = Anchor.center;
    background.position = centerPosition;
    add(background);
    /*
    planets = [
      Planet(imagePath: 'mars_planet.png', position: Vector2(100, centerPosition.y)),
      Planet(imagePath: 'ice_planet.png', position: Vector2(500, centerPosition.y)),
      Planet(imagePath: 'fire_planet.png', position: Vector2(900, centerPosition.y)),
    ];
    for (var planet in planets) {
      add(planet);
    }
    */
    planets = [
      SpriteComponent()..sprite = await Sprite.load('mars_planet.png')
    ];
    for (SpriteComponent planet in planets) {
      planet.size = calcSpriteSize(planet.sprite!.originalSize, 0.5);
      planet.anchor = Anchor.center;
      planet.position = centerPosition;
      add(planet);
    }
    
    //_updateFocus();
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
/*
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
*/
  Vector2 calcSpriteSize(Vector2 originalSize, double scale) {
    final screenAspectRatio = gameRef.size.x / gameRef.size.y;
    final imageAspectRatio = originalSize.x / originalSize.y;
    if (screenAspectRatio > imageAspectRatio) {
      return Vector2(gameRef.size.x , gameRef.size.x / imageAspectRatio) * scale;
    } else {
      return Vector2(gameRef.size.y * imageAspectRatio, gameRef.size.y) * scale;
    }
  }
/*
  @override
  void render (Canvas canvas ){
    final paint = Paint()..color = Colors.black;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      paint,
    );

    for (final planet in planets) {
      //final centerX = gameRef.size.x / 2 + offset.dx + planets.indexOf(planet) * gameRef.size.x;
      planet.render(canvas);
    }
  }
  */
}
/*
class Planet extends SpriteComponent with HasGameRef<PlanetCityBuilder>, TapCallbacks{
  final String imagePath;
  bool isFocused = false;

  Planet({required this.imagePath, required Vector2 position}) {
    this.position = position;
    size = Vector2(400,300);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(imagePath);
    sprite.srcSize = gameRef.size / 2;
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

  @override
  void onTapUp(TapUpEvent event) {
    game.router.pushNamed('maingame');
  }
}

// Wrap PlanetSelectScreen with GestureDetector in your game widget to handle gestures
*/
