import 'package:cs_545_jahnu_best/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/widgets.dart';

void main() {
  runApp(GameWidget(game: PlanetCityBuilder()));
}

class PlanetCityBuilder extends FlameGame {
  @override
  Future<void> onLoad() async {
    await add(LoadingScreen());
  }
}
