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

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            ColorTheme.primary.withOpacity(0.2),
            ColorTheme.primary.withOpacity(0.05),
          ],
          stops: const [0.6, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorTheme.primary,
                ColorTheme.primary.withOpacity(0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: ColorTheme.primary.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              formattedValue,
              style: TextStyle(
                fontFamily: FontTheme().fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
