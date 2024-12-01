import 'dart:convert';
import 'dart:io';

import 'package:flame/events.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flame/components.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planet_city_builder/game_components/building.dart';
import 'package:planet_city_builder/main.dart';
import 'package:planet_city_builder/game_components/zone.dart';
import 'package:planet_city_builder/game_components/city_name_component.dart';
import 'package:planet_city_builder/game_components/city_population_component.dart';
import 'package:planet_city_builder/game_components/city_balance_component.dart';
import 'package:flame/game.dart';
import 'dart:math';

class MainGameScreen extends Component with HasGameRef<PlanetCityBuilder>{
  late CameraComponent camera;
  late CityNameComponent cityNameComponent = CityNameComponent();
  late CityPopulationComponent cityPopulationComponent = CityPopulationComponent();
  late CityBalanceComponent cityBalanceComponent = CityBalanceComponent();
  late SpriteComponent background;

  late OverlayEntry renameOverlay;
  //Timer autosaveTmer = Timer(5, repeat: true);
  Stopwatch elapsedTime = Stopwatch();
  Stopwatch autosaveTicker = Stopwatch();
  //final TextEditingController _controller = TextEditingController();

  List<Zone> zones = [];
  Map demand = <ZoneType, double>{
    ZoneType.residential:0.0,
    ZoneType.commercial:0.0,
    ZoneType.industrial:0.0
  };
  final Random rng = Random();
  final double initialZoneRadius = 50;
  late Vector2 defaultZoneSize;

  @override
  Future<void> onLoad() async {
    background = SpriteComponent()
      ..sprite = await Sprite.load('mars_background.jpg');
    background.size = calculateBackgroundSize(background.sprite!.originalSize);
    background.anchor = Anchor.center;
    background.position = gameRef.size / 2;
    addAll([
      background,
      cityNameComponent,   
      cityPopulationComponent,
      cityBalanceComponent,
      BackButton(),
      PauseButton(),
    ]);
    defaultZoneSize = Vector2(gameRef.size.length / 13, gameRef.size.length / 13);
    final gameData = await loadGameData();
    if (gameData != null) {
      setGameFromData(gameData);
    } else {  //Loading game for the first time
      _initializeZones();
    }
    elapsedTime.start();
    autosaveTicker.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    saveData();
  }

  Vector2 calculateBackgroundSize(Vector2 originalSize) {
    final screenAspectRatio = gameRef.size.x / gameRef.size.y;
    final imageAspectRatio = originalSize.x / originalSize.y;
    if (screenAspectRatio > imageAspectRatio) {
      return Vector2(gameRef.size.x, gameRef.size.x / imageAspectRatio);
    } else {
      return Vector2(gameRef.size.y * imageAspectRatio, gameRef.size.y);
    }
  }
/*
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    background.size = calculateBackgroundSize(background.sprite!.originalSize);
    background.anchor = Anchor.center;
    background.position = Vector2(size.x / 2, size.y - 50);  

  }
  */
/*
  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Move the camera position based on drag delta
    camera.viewfinder.moveBy(-event.localDelta);
  }
  */
/*
  @override
  void render(Canvas canvas) {
    background.render(canvas);
    for (var zone in zones) {
      zone.render(canvas);
      for (var building in zone.buildings){
        building.render(canvas);
      }
    }
    cityNameComponent.render(canvas);
    cityPopulationComponent.render(canvas);
  }
*/

  @override
  void update(double dt) {
    super.update(dt);
    if (autosaveTicker.elapsed.inSeconds >= 5) {
      print("5 seconds have passed, autosaving (change to every 5 mins)");
      saveData();
      autosaveTicker.reset();
    }

    if (zones.isEmpty) {  //Shouldn't happen
      _initializeZones();
    }

    //Adjust demand for each zone type
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
    
    //Increase population of each zone based on building population growth
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

  Future<File> _getGameDataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/gameData.json');
  }

  Future<void> saveData() async {
    final file = await _getGameDataFile();
    String jsonData = jsonEncode(getSaveState());
    await file.writeAsString(jsonData);
  }

/*
Not everything is currently saved. Some data will be missing.
Complete data will be added to save states as game development expands.
Functionality will likely change, which means save data changes too.
*/

  Map<String, dynamic> getSaveState() {
    return {
      'cityname' : cityNameComponent.cityName,
      'zones' : zones.map((zone) => {
        'type' : zone.type.toString(),
        'position' : {'x' : zone.position.x, 'y' : zone.position.y},
        'size' : zone.size,
        'buildings' : zone.buildings.map((building) => {
          'position' : {'x': building.position.x, 'y': building.position.y},
          'population' : building.population,
        }).toList(),
      }).toList(),
      'lastSaveTime' : DateTime.now().toIso8601String(),
    };
  }

  void setGameFromData(Map<String, dynamic> gameData) {
    cityNameComponent.cityName = gameData['cityname'];
    zones = List.empty();
    cityPopulationComponent.population = 0;
    for (final zone in gameData['zones']) {
      Zone newZone = Zone(zone['type'], zone['position'], zone['size']);
      for (final building in zone['buildings']) {
        Building newBuilding = Building(building['position']);
        newBuilding.population = building['population'];
        cityPopulationComponent.population += newBuilding.population;
        newZone.add(newBuilding);
      }
      zones.add(newZone);
    }
  }

  Future<Map<String, dynamic>?> loadGameData() async {
    try {
      final file = await _getGameDataFile();
      if (await file.exists()) {
        String jsonData = await file.readAsString();
        return jsonDecode(jsonData);
      }
    } catch (e) {
      print("Error loading game data: $e");
    }
    return null;
  }
}

abstract class SimpleButton extends PositionComponent with TapCallbacks {
  SimpleButton(this._iconPath, {super.position}) : super(size: Vector2.all(40));

  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0x66ffffff);
  final Paint _iconPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xffaaaaaa)
    ..strokeWidth = 7;
  final Path _iconPath;

  void action();

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      _borderPaint,
    );
    canvas.drawPath(_iconPath, _iconPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _iconPaint.color = const Color(0xffffffff);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _iconPaint.color = const Color(0xffaaaaaa);
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _iconPaint.color = const Color(0xffaaaaaa);
  }
}

class BackButton extends SimpleButton with HasGameReference<PlanetCityBuilder> {
  BackButton()
      : super(
          Path()
            ..moveTo(22, 8)
            ..lineTo(10, 20)
            ..lineTo(22, 32)
            ..moveTo(12, 20)
            ..lineTo(34, 20),
          position: Vector2.all(10),
        );

  @override
  void action() => game.router.pop();
}

class PauseButton extends SimpleButton with HasGameReference<PlanetCityBuilder> {
  PauseButton()
      : super(
          Path()
            ..moveTo(14, 10)
            ..lineTo(14, 30)
            ..moveTo(26, 10)
            ..lineTo(26, 30),
          position: Vector2(60, 10),
        );

  @override
  void action() => game.router.pushNamed('pause');
}

class PauseRoute extends Route {
  PauseRoute() : super(PausePage.new, transparent: true);

  @override
  void onPush(Route? previousRoute) {
    previousRoute!
      ..stopTime()
      ..addRenderEffect(PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0));
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute
      ..resumeTime()
      ..removeRenderEffect();
  }
}

class PausePage extends Component
    with TapCallbacks, HasGameRef<PlanetCityBuilder> {
  @override
  Future<void> onLoad() async {
    add(
      TextComponent(
        text: 'Paused',
        position: gameRef.canvasSize / 2,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => game.router.pop();
}