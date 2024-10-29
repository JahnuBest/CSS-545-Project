import 'package:planet_city_builder/game_screen.dart';
import 'package:planet_city_builder/main.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class LoadingScreen extends Component with HasGameRef<PlanetCityBuilder>{
  late SpriteComponent background;
  late RectangleComponent progressBar;
  late RectangleComponent progressBarFill;
  late TextComponent titleText;
  double fadeOpacity = 1.0;
  double progress = 0.0;
  bool fadeOut = false;

  @override
  Future<void> onLoad() async {
    background = SpriteComponent()
      ..sprite = await Sprite.load('loading_background_img.jpeg');

    background.size = calculateBackgroundSize(background.sprite!.originalSize);
    background.anchor = Anchor.center;
    background.position = gameRef.size / 2;
    add(background);

    titleText = TextComponent(
      text: "Planet City Builder 0.1.0",
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: "GameOfSquids"
        )
      )
    );
    titleText.anchor = Anchor.center;
    titleText.position = Vector2(gameRef.size.x / 2, gameRef.size.y * 0.1);
    add(titleText);

    progressBar = RectangleComponent(
      position: Vector2(gameRef.size.x * 0.2, gameRef.size.y * 0.8),
      size: Vector2(gameRef.size.x * 0.6, 20),
      paint: BasicPalette.white.paint(),
    );
    add(progressBar);

    progressBarFill = RectangleComponent(
      position: Vector2(gameRef.size.x * 0.2, gameRef.size.y * 0.8),
      size: Vector2(0, 20),
      paint: BasicPalette.green.paint(),
    );
    add(progressBarFill);
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

  
  void applyFadeEffect(double opacity) {
    final fadedPaint = Paint()..color = Colors.white.withOpacity(opacity);

    background.paint = fadedPaint;
    titleText.textRenderer = TextPaint(
      style: TextStyle(
        fontFamily: 'GameOfSquids',
        color: Colors.white.withOpacity(opacity),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
    //progressBar.paint = fadedPaint;
    //progressBarFill.paint = fadedPaint;
  }


  @override
  void update(double dt) {
    super.update(dt);
    if (!fadeOut) {
      if (progress >= 1.0) {
        fadeOut = true;
        progressBar.removeFromParent();
        progressBarFill.removeFromParent();
      }
      else {
        progress += dt * 2;
        progressBarFill.size.x = progressBar.size.x * progress;
      }
    } else {
      fadeOpacity -= dt * 2;
      //applyFadeEffect(fadeOpacity);
      if (fadeOpacity <= 0) {
        fadeOpacity = 0;
        //game.router.remove(this);
        game.router.pushNamed('maingame');
      }
    }
  } 
}