import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/shared/component/shimmer.dart';
import 'package:soleh/themes/colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.currentTime,
    required this.currentMeridiem,
    required this.currentHijrahDate,
    required this.currentLocation,
  });

  final String currentTime;
  final String currentMeridiem;
  final String currentHijrahDate;
  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(100),
      ),
      child: Container(
        height: 120,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(100),
          ),
          color: ColorTheme.primary,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                currentLocation == ''
                    ? const ShimmerLoad(height: 20, width: 50)
                    : Row(
                        children: [
                          const Icon(
                            FluentIcons.location_24_filled,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            currentLocation,
                            style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                Row(
                  children: [
                    currentTime == ''
                        ? const ShimmerLoad(height: 50, width: 80)
                        : Text(
                            currentTime,
                            style: TextStyle(
                              fontFamily: GoogleFonts.staatliches().fontFamily,
                              fontSize: 55,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(width: 5),
                    currentMeridiem == ''
                        ? const ShimmerLoad(height: 10, width: 30)
                        : Text(
                            currentMeridiem,
                            style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(width: 20),
                    Container(
                      width: 10,
                      height: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 20),
                    currentHijrahDate == ''
                        ? const ShimmerLoad(height: 20, width: 100)
                        : Text(
                            currentHijrahDate,
                            style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ],
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
