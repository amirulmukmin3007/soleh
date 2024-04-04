import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/themes/colors.dart';

class CircleButton extends StatelessWidget {
  final IconData iconData;
  final Color buttonColor;
  final Color iconColor;
  final String waktuText;
  final String timeText;
  final VoidCallback onPressed;

  const CircleButton({
    super.key,
    required this.iconData,
    required this.buttonColor,
    required this.iconColor,
    required this.waktuText,
    required this.timeText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: buttonColor.withOpacity(0.3),
            ),
            child: Center(
              child: Icon(
                iconData,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            waktuText,
            style: TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: const Color.fromARGB(255, 110, 110, 110),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            timeText,
            style: TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: ColorTheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
