//City Name Textbox
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:planet_city_builder/main.dart';

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
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, size.y - 100);
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