import 'dart:collection';
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

class ZoneInfoComponent extends PositionComponent {
  /*
  ZoneInfoComponent(

  );
  */

  Map<String, int> resources = {
        "Iron":2, "Oil": 24, "Uranium":5
      };

  @override
  Future<void> onLoad() async {
    //Change later
    for (var resource in resources.entries) {
      add(
        TextComponent(
          text: "${resource.key}: ${resource.value}t",
          textRenderer: TextPaint(
            style: const TextStyle(
            fontSize: 12,
            fontFamily: "Cartesian",
            color: Colors.black,
            ),
          )
        )
      );
    }
  }

  

}