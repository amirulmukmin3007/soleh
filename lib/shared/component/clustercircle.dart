import 'package:flutter/material.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class ClusterCircle extends StatelessWidget {
  const ClusterCircle({super.key, required this.numericValue});
  final String numericValue;

  @override
  Widget build(BuildContext context) {
    Formatter formatter = Formatter();
    String formattedValue = formatter.formatNumericValue(numericValue);

    return Material(
      elevation: 8,
      shape: const CircleBorder(),
      child: Container(
        width: 40, // outer circle width
        height: 40, // outer circle height
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 139, 202, 145), // outer circle color
        ),
        child: Center(
          child: Container(
            width: 30, // inner circle width
            height: 30, // inner circle height
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorTheme.primary, // inner circle color
            ),
            child: Center(
              child: Text(
                formattedValue,
                style: TextStyle(
                  fontFamily: FontTheme().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
