import 'package:flutter/material.dart';
import 'package:soleh/themes/fonts.dart';

class InfoBar extends StatelessWidget {
  const InfoBar({
    super.key,
    required this.textDisplay,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  final String textDisplay;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(
            255,
            200,
            200,
            200,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(
                  50,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
          ),
          Text(
            textDisplay,
            style: TextStyle(
              fontSize: 14,
              fontFamily: fontTheme.fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoBarClickable extends StatelessWidget {
  const InfoBarClickable({
    super.key,
    required this.textDisplay,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.function,
  });

  final String textDisplay;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 200, 200, 200),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
            Text(
              textDisplay,
              style: TextStyle(
                fontSize: 14,
                fontFamily: fontTheme.fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
