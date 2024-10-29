import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:planet_city_builder/main.dart';
import 'package:planet_city_builder/game_components/zone.dart';
import 'dart:math';

class MainGameScreen extends Component with HasGameRef<PlanetCityBuilder>{
  late CameraComponent camera;
  late CityNameComponent cityNameComponent = CityNameComponent();
  late CityPopulationComponent cityPopulationComponent = CityPopulationComponent();

  late OverlayEntry renameOverlay;
  //final TextEditingController _controller = TextEditingController();

  List<Zone> zones = [];
  Map demand = <ZoneType, double>{
    ZoneType.residential:0.0,
    ZoneType.commercial:0.0,
    ZoneType.industrial:0.0
  };
  final Random rng = Random();
  final double initialZoneRadius = 50;
  
  final Vector2 defaultZoneSize = Vector2(150,150);

  MainGameScreen() {
    addAll([
      cityNameComponent,   // Clickable text box for renaming city
      cityPopulationComponent,   // Non-clickable text box for population
    ]);
    //camera = CameraComponent(world: this, viewport: FixedResolutionViewport(Vector2(800, 600)));
  }

/*
  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Move the camera position based on drag delta
    camera.viewfinder.moveBy(-event.localDelta);
  }
  */
  @override
  void update(double dt) {
    super.update(dt);

    if (zones.isEmpty) {
      _initializeZones();
    }
    for (ZoneType ztd in demand.keys) {
      demand[ztd] += rng.nextDouble() * dt * 0.002;
      demand[ztd] = demand[ztd].clamp(0.0, 1.0);
      if (rng.nextDouble() < demand[ztd]) {
        var zoneTypeList = getZonesType(ztd);
        zoneTypeList = zoneTypeList.where((zone) => zone.zoneSlots.isNotEmpty).toList(); //Only include zones with available spots
        if (zoneTypeList.isNotEmpty) {
          zoneTypeList[rng.nextInt(zoneTypeList.length)].generateBuildings();
        } else {
          //Generate new zone of demanded type, for now placement is random
          Vector2 position;
          Zone existingZone = zones[Random().nextInt(zones.length)];
          position = getAdjacentPosition(existingZone.position, defaultZoneSize);
          Zone newZone = Zone(ztd, position, defaultZoneSize);
          zones.add(newZone);
          add(newZone);
        }
        demand[ztd] = 0.0;
      }
    }
    

    for (var zone in zones) {
      for (var building in zone.buildings){
        if (building.popIncrease > 0) {
          cityPopulationComponent.population += building.popIncrease;
          //print("Increased pop by ${building.popIncrease}");
          building.popIncrease = 0;
        }
      }
    }
  }

  void _initializeZones() {
    final center = gameRef.size / 2;

    for (var zoneType in ZoneType.values) {
      Vector2 position;
      if (zones.isEmpty){
        position = center + getRandomOffset(initialZoneRadius);
      } else {
        //List<Zone> possibleZones = zones; 
        Zone existingZone = zones[Random().nextInt(zones.length)];
        position = getAdjacentPosition(existingZone.position, defaultZoneSize);
          //possibleZones.remove(existingZone); //Ensures we don't check the same zone twice
      }
      Zone newZone = Zone(zoneType, position, defaultZoneSize);
      zones.add(newZone);
      add(newZone); 
    }
  }

  Vector2 getRandomOffset(double radius) {
    final rng = Random();
    final angle = rng.nextDouble() * 2 * pi;
    final distance = rng.nextDouble() * (radius - 50);
    return Vector2(cos(angle) * distance, sin(angle) * distance);
  }

  bool isOverlapping(Vector2 position) {
    for (var zone in zones) {
      if (zone.isOverlapping(position, zone.size)) {
        return true;
      }
    }
    return false;
  }
  
  Vector2 getAdjacentPosition(Vector2 existingPosition, Vector2 size) {
    final rng = Random();
    List<Vector2> options = [];
    options.addAll([
      existingPosition + Vector2(0, - size.y),
      existingPosition + Vector2(0, size.y),
      existingPosition + Vector2(-size.x, 0),
      existingPosition + Vector2(size.x, 0)
    ]);
    for (var option in options){
      if (isOverlapping(option)) {
        options.remove(option);
      }
    }
    if (options.isNotEmpty) {
      return options[rng.nextInt(options.length)];
    } else {
      throw Exception("Failed to find adjacent zone placement");
    }
  }

  List<Zone> getZonesType(ZoneType type) {
    return zones.where((zone) => zone.type == type).toList();
  }
}

class CityNameComponent extends PositionComponent with TapCallbacks, HasGameRef<PlanetCityBuilder> {
  CityNameComponent() {
   _textComponent = TextComponent(
      text: cityName,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontFamily: "GameOfSquids",
          color: Colors.black,
        ),
      ),
      anchor: Anchor.center,
    );
    add(_textComponent);
  }

  String cityName = 'Capitol City';
  late TextComponent _textComponent;
  @override
  int priority = 100;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, size.y - 100); // Bottom center position
  }

  @override
  void onTapUp(TapUpEvent event) {
    _showRenameDialog();
  }

  void _showRenameDialog() {
    return;
    /*
    final overlay = OverlayEntry(
      builder: (context) {
        String newCityName = cityName;

        return Center(
          child: Material(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter new city name'),
                    onChanged: (value) => newCityName = value,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cityName = newCityName;
                          _textComponent.text = cityName;
                          Overlay.of(context).remove(overlay);
                        },
                        child: Text('Submit'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Overlay.of(context).remove(overlay);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Insert the overlay into the widget tree
    Overlay.of(context).insert(overlay);
    */
  }
}

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
  int priority = 99;  

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