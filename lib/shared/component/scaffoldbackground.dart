import 'package:flutter/material.dart';

class ScaffoldBackground extends StatelessWidget {
  const ScaffoldBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.0, -1.0),
            end: Alignment(0.0, 1.0),
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 184, 204, 186),
            ],
          ),
        ),
        child: child);
  }
}
