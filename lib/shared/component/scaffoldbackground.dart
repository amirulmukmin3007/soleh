import 'package:flutter/material.dart';
// import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// import 'package:soleh/themes/colors.dart';

class ScaffoldBackground extends StatelessWidget {
  const ScaffoldBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    // final iconSize = screenWidth > 600
    // ? screenWidth * 0.8 // Tablets
    // : screenWidth * 1.2; // Phones

    // final leftPosition = -iconSize * 0.25;
    // final bottomPosition = -iconSize * 0.02;

    return Stack(
      children: [
        Container(
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
        ),
        // Positioned(
        //     bottom: bottomPosition,
        //     left: leftPosition,
        //     child: ShaderMask(
        //       shaderCallback: (Rect bounds) {
        //         return LinearGradient(
        //           colors: [
        //             ColorTheme.primary.withValues(alpha: 0.2),
        //             ColorTheme.primary.withValues(alpha: 0.5),
        //             ColorTheme.primary.withValues(alpha: 0.2),
        //           ],
        //           begin: Alignment.topLeft,
        //           end: Alignment.bottomRight,
        //         ).createShader(bounds);
        //       },
        //       child: Icon(
        //         FlutterIslamicIcons.islam,
        //         size: iconSize,
        //         color: Colors.white, // This color will be replaced by gradient
        //       ),
        //     )),
        child,
      ],
    );
  }
}
