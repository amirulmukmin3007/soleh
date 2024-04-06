import 'package:flutter/material.dart';

class ColorTheme {
  static const Color primary = Color(0xFF436947);

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
