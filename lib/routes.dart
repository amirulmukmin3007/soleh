import 'package:flutter/material.dart';
import 'package:soleh/features/home/screens/home.dart';
import 'package:soleh/view/map.dart';
import 'package:soleh/view/qibla.dart';
import 'package:soleh/view/settings.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final bool isActive = settings.arguments as bool? ?? false;

  switch (settings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
    case Qibla.routeName:
      return MaterialPageRoute(
        builder: (context) => Qibla(isActive: isActive),
      );
    case MosqueMap.routeName:
      return MaterialPageRoute(
        builder: (context) => MosqueMap(isActive: isActive),
      );
    case Settings.routeName:
      return MaterialPageRoute(
        builder: (context) => Settings(isActive: isActive),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
  }
}
