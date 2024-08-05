import 'package:flutter/material.dart';

class Qibla extends StatefulWidget {
  static const routeName = '/qibla';
  const Qibla({super.key, required this.isActive});

  final bool isActive;

  @override
  State<Qibla> createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
