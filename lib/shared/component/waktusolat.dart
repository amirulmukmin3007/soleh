import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/shared/component/circlebutton.dart';
import 'package:soleh/themes/colors.dart';

class WaktuSolat extends StatelessWidget {
  const WaktuSolat(
      {super.key,
      required this.subuh,
      required this.zohor,
      required this.asar,
      required this.maghrib,
      required this.isyak});
  final String subuh;
  final String zohor;
  final String asar;
  final String maghrib;
  final String isyak;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Waktu Azan',
                style: TextStyle(
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontSize: 18,
                  color: ColorTheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Divider(
              color: ColorTheme.primary,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleButton(
                  iconData: FluentIcons.weather_sunny_low_24_regular,
                  buttonColor: ColorTheme.primary,
                  iconColor: ColorTheme.primary,
                  waktuText: 'Subuh',
                  timeText: subuh,
                  onPressed: () {},
                ),
                const SizedBox(width: 5),
                CircleButton(
                  iconData: FluentIcons.weather_sunny_16_regular,
                  buttonColor: ColorTheme.primary,
                  iconColor: ColorTheme.primary,
                  waktuText: 'Zohor',
                  timeText: zohor,
                  onPressed: () {},
                ),
                const SizedBox(width: 5),
                CircleButton(
                  iconData: FluentIcons.weather_sunny_high_48_regular,
                  buttonColor: ColorTheme.primary,
                  iconColor: ColorTheme.primary,
                  waktuText: 'Asar',
                  timeText: asar,
                  onPressed: () {},
                ),
                const SizedBox(width: 5),
                CircleButton(
                  iconData: FluentIcons.weather_partly_cloudy_night_24_regular,
                  buttonColor: ColorTheme.primary,
                  iconColor: ColorTheme.primary,
                  waktuText: 'Maghrib',
                  timeText: maghrib,
                  onPressed: () {},
                ),
                const SizedBox(width: 5),
                CircleButton(
                  iconData: FluentIcons.weather_moon_16_regular,
                  buttonColor: ColorTheme.primary,
                  iconColor: ColorTheme.primary,
                  waktuText: 'Isyak',
                  timeText: isyak,
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
