import 'package:planet_city_builder/loading_screen.dart';
import 'package:planet_city_builder/game_screen.dart';
import 'package:planet_city_builder/planet_select_screen.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flame/game.dart';
//import 'package:flame/components.dart';
//import 'package:flame/events.dart';
//import 'package:flame/geometry.dart';
//import 'package:flame/palette.dart';
//import 'package:flame/widgets.dart';

void main() {
  runApp(GameWidget(game: PlanetCityBuilder()));
}

class PlanetCityBuilder extends FlameGame {
  late final RouterComponent router;

  @override
  Color backgroundColor() => const Color(0xFFD3D3D3);

  @override
  Future<void> onLoad() async {
    add (
      router = RouterComponent(
        routes: {
          'loading': Route(LoadingScreen.new),
          'planetselect': Route(PlanetSelectScreen.new),
          'maingame': Route(MainGameScreen.new),
          'pause': PauseRoute(),
        },
        initialRoute: 'loading',
      ),
    ); 
  }
}
