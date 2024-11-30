import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CityBalanceComponent extends TextComponent {
  CityBalanceComponent({int initialBalance = 123456789})
      : balance = initialBalance,
        super(
          text: 'Bank Balance: $initialBalance',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "GameOfSquids",
              color: Colors.black54,
            ), 
          ),
          anchor: Anchor.center,
        );

  int balance;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, 50);  
  }

  @override
  void update(double dt) {
    super.update(dt);
    String formattedBalance = NumberFormat.decimalPattern().format(balance);
    if (text != 'Bank Balance: \$$formattedBalance') {
      text = 'Bank Balance: \$$formattedBalance';
      position = Vector2(size.x / 2, 50);  
    }
  }
}