import 'package:flutter/material.dart';
import 'package:soleh/view/home.dart';
import 'package:soleh/view/masjid_location.dart';
import 'package:soleh/view/qibla.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Home.routeName:
      return MaterialPageRoute(builder: (context) => const Home());
    case MasjidLocation.routeName:
      return MaterialPageRoute(builder: (context) => const MasjidLocation());
    case Qibla.routeName:
      return MaterialPageRoute(builder: (context) => const Qibla());
    default:
      return MaterialPageRoute(builder: (context) => const Home());
  }
}
