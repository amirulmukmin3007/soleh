import 'package:flutter/material.dart';

class ColorTheme {
  static const Color primary = Color(0xFF1a472a);
  static const Color glow = Color(0xFFFFAB45);

  Decoration gradient = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        primary,
      ],
    ),
  );
}
