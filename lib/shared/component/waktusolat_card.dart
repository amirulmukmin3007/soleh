import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/shared/component/circlebutton.dart';
import 'package:soleh/shared/component/shimmer.dart';
import 'package:soleh/themes/colors.dart';

class WaktuSolatCard extends StatefulWidget {
  const WaktuSolatCard({
    super.key,
    required this.currentWaktuSolat,
    required this.subuh,
    required this.syuruk,
    required this.zohor,
    required this.asar,
    required this.maghrib,
    required this.isyak,
    required this.today,
  });

  final String currentWaktuSolat;
  final String subuh;
  final String syuruk;
  final String zohor;
  final String asar;
  final String maghrib;
  final String isyak;
  final String today;

  @override
  State<WaktuSolatCard> createState() => _WaktuSolatState();
}

class _WaktuSolatState extends State<WaktuSolatCard> {
  List<String> waktuSolatList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
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
                child: widget.today == ''
                    ? const ShimmerLoad(height: 30, width: 200)
                    : Text(
                        widget.today,
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
                    buttonColor: widget.currentWaktuSolat == 'Subuh'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Subuh'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Subuh',
                    timeText: widget.subuh,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_sunny_16_regular,
                    buttonColor: widget.currentWaktuSolat == 'Zohor'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Zohor'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Zohor',
                    timeText: widget.zohor,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_sunny_high_48_regular,
                    buttonColor: widget.currentWaktuSolat == 'Asar'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Asar'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Asar',
                    timeText: widget.asar,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData:
                        FluentIcons.weather_partly_cloudy_night_24_regular,
                    buttonColor: widget.currentWaktuSolat == 'Maghrib'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Maghrib'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Maghrib',
                    timeText: widget.maghrib,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_moon_16_regular,
                    buttonColor: widget.currentWaktuSolat == 'Isyak'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Isyak'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Isyak',
                    timeText: widget.isyak,
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
