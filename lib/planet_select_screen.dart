import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:planet_city_builder/main.dart';

class PlanetSelectScreen extends Component with HasGameRef<PlanetCityBuilder>, DragCallbacks, TapCallbacks {
  int currentPlanetIndex = 0;
  late SpriteComponent background = SpriteComponent();
  List<Planet> planets = [];
  late Planet focusedPlanet;
  TextComponent planetName = TextComponent(
    anchor: Anchor.center,
    textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 50,
          fontWeight: FontWeight.bold,
          fontFamily: "GameOfSquids"
        )
      )
  );
  TextComponent planetInfo = TextComponent(
    anchor: Anchor.center,
    text: "",
    textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: "GameOfSquids"
        )
      )
  );
  bool isDragging = false;
  late Vector2 centerPosition; // Centered position for focused planet
  Offset offset = Offset.zero;
  
  //centerPosition = Vector2(gameRef.size.x / 2, gameRef.size.y); 

  @override
  Future<void> onLoad() async {
    centerPosition = gameRef.size / 2;
    background.sprite = await Sprite.load('stars.jpg');
    add(background);
    add(planetName);
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
      //Planet(imagePath: "mars_planet_png", name: "Mars", position: centerPosition)
      //..sprite = await Sprite.load("mars_planet.png")
      //SpriteComponent()..sprite = await Sprite.load("mars_planet.png")
      Planet(centerPosition, 0.75, "Mars", {
        "Resources": "Plenty",
        "Temperature": "Hot",
        "Gravity": "Low",
      })..sprite = await Sprite.load("mars_planet.png"),
      Planet(Vector2(centerPosition.x + 500, centerPosition.y), 0.5, "Ice Planet",
      {
        "Resources": "Plenty",
        "Temperature": "Hot",
        "Gravity": "Low",
      })..sprite = await Sprite.load("ice_planet.png"),
      Planet(Vector2(centerPosition.x + 1000, centerPosition.y), 0.5, "Fire Planet",
      {
        "Resources": "Plenty",
        "Temperature": "Hot",
        "Gravity": "Low",
      })..sprite = await Sprite.load("fire_planet.png")
      //  ..position = Vector2(centerPosition.x + 500, centerPosition.y)
      //..size = Vector2(gameRef.size.y * 0.5, gameRef.size.y * 0.5)
    ];
    focusedPlanet = planets[0];
    focusedPlanet.isFocused = true;
    planetName.text = focusedPlanet.name;
    for (var entry in focusedPlanet.planetInfo.entries) {
        planetInfo.text += "${entry.key}: ${entry.value}\n";
    }
    planetInfo.position = Vector2(centerPosition.x, gameRef.size.y - 300);
    add(planetInfo);
    for (SpriteComponent planet in planets) {      
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

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    planetName.position = Vector2(gameRef.size.x / 2, 100);
    planetInfo.position = Vector2(centerPosition.x, gameRef.size.y - 100);
    //background.size = gameRef.size * 1.5;
    //background.anchor = Anchor.center;
    //background.position = centerPosition;
    //focusedPlanet.size = calcSpriteSize(focusedPlanet.sprite!.originalSize, 0.5);
    //focusedPlanet.anchor = Anchor.center;
    //focusedPlanet.position = centerPosition;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (planetName.text != focusedPlanet.name) {
      planetName.text = focusedPlanet.name;
    }
    for (Planet planet in planets) {
      if (planet != focusedPlanet) {
        planet.position.x += focusedPlanet.offset;
      }
    }
    background.position.x += focusedPlanet.offset * 0.1;
    if (!focusedPlanet.isFocused) {
      //New planet to focus
      if (focusedPlanet.position.x - centerPosition.x > 0){
        focusedPlanet = planets[planets.indexOf(focusedPlanet) - 1]; // THIS WON'T WORK IF FOCUSED PLANET IS FIRST IN LIST
      } else {
        focusedPlanet = planets[planets.indexOf(focusedPlanet) + 1]; // THIS WON'T WORK IF FOCUSED PLANET IS LAST IN LIST
      }
      focusedPlanet.position = centerPosition;
      focusedPlanet.scale = Vector2(0.75, 0.75);
      focusedPlanet.isFocused = true;
      planetInfo.text = "";
      for (var entry in focusedPlanet.planetInfo.entries) {
        planetInfo.text += "${entry.key}: ${entry.value}\n";
      }
    }
  }

  

/*
@override
void onTapUp(TapUpEvent event) {
  if (event.localPosition )
}
  */
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

class Planet extends SpriteComponent with HasGameRef<PlanetCityBuilder>, DragCallbacks, TapCallbacks {
  late TextComponent nameText;
  bool isFocused = false;
  bool isDragging = false;
  String name = "";
  double offset = 0.0;
  Map planetInfo = <String, String>{};

  Planet(Vector2 pos, double s, String n, Map<String, String> pi) : super() {
    scale = Vector2(s, s);
    position = pos;
    anchor = Anchor.center;
    name = n;
    planetInfo = pi;
  }
/*
  Planet({required this.imagePath, required String name, required Vector2 position}) {
    this.position = position;
    nameText = TextComponent(
      position: Vector2(position.x, 50),
      text: name,
      textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 30,
              fontFamily: "GameOfSquids",
              color: Colors.white,
            ),
          ),
    );
  }
*/

  @override
  Future<void> onLoad() async {
    size = calcSpriteSize(sprite!.originalSize, scale);
    //position = gameRef.size / 2;
    //add(nameText);
  }
  

  @override
  void onDragStart(DragStartEvent event){
    super.onDragStart(event);
    if (isFocused) {
      isDragging = true;
      scale = Vector2(0.8,0.8);
    }
    //size = calcSpriteSize(sprite!.originalSize, scale);
  }

  @override
  void onDragUpdate(DragUpdateEvent event){
    super.onDragUpdate(event);
    if (isDragging){
      position.x += event.localDelta.x;
      offset = event.localDelta.x;
    }
  }

  @override
  void onDragEnd(DragEndEvent event){
    super.onDragEnd(event);
    isDragging = false;
    offset = 0;
    if (((gameRef.size.x / 2) - position.x).abs() > (400 * (gameRef.size.y / 1920))) {
      if ((gameRef.size.x / 2) - position.x > 0){
        position.x = 200;
      } else {
        position.x = gameRef.size.x - 200;
      }
      scale = Vector2(0.25,0.25);
      isFocused = false;
      //size = calcSpriteSize(sprite!.originalSize, s);
    }
    else {
      position = gameRef.size / 2;
      scale = Vector2(0.75,0.75);
      //size = calcSpriteSize(sprite!.originalSize, s);
    }
    
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    scale = Vector2(0.75,0.75);
    game.router.pushNamed('maingame');
  }

   @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    scale = Vector2(0.6,0.6);
  }

  Vector2 calcSpriteSize(Vector2 originalSize, Vector2 scale) {
    final screenAspectRatio = gameRef.size.x / gameRef.size.y;
    final imageAspectRatio = originalSize.x / originalSize.y;
    if (screenAspectRatio > imageAspectRatio) {
      return Vector2(gameRef.size.x * scale.x, (gameRef.size.x / imageAspectRatio) * scale.y);
    } else {
      return Vector2((gameRef.size.y * imageAspectRatio) * scale.x, gameRef.size.y * scale.y);
    }
  }
}