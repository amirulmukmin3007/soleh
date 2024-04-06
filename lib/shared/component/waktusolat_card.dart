import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/model/home_model.dart';
import 'package:soleh/shared/component/circlebutton.dart';
import 'package:soleh/shared/component/shimmer.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:soleh/themes/colors.dart';

class WaktuSolatCard extends StatefulWidget {
  const WaktuSolatCard({
    super.key,
    required this.subuh,
    required this.zohor,
    required this.asar,
    required this.maghrib,
    required this.isyak,
    required this.today,
    required this.homeModel,
    required this.formatter,
  });
  final String subuh;
  final String zohor;
  final String asar;
  final String maghrib;
  final String isyak;
  final String today;
  final HomeModel homeModel;
  final Formatter formatter;

  @override
  State<WaktuSolatCard> createState() => _WaktuSolatState();
}

class _WaktuSolatState extends State<WaktuSolatCard> {
  String currentWaktuSolat = '';

  @override
  void initState() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            widget.homeModel.waktuSolatToday = [
              widget.subuh,
              widget.zohor,
              widget.asar,
              widget.maghrib,
              widget.isyak
            ];
            if (widget.homeModel.waktuSolatFlag &&
                widget.subuh != '' &&
                widget.zohor != '' &&
                widget.asar != '' &&
                widget.maghrib != '' &&
                widget.isyak != '') {
              currentWaktuSolat = widget.formatter.getCurrentWaktuSolat(
                  widget.homeModel.waktuSolatToday,
                  widget.homeModel.waktuSolatList);
            }
          },
        );
      },
    );
    super.initState();
  }

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
                    buttonColor: currentWaktuSolat == 'Subuh'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: currentWaktuSolat == 'Subuh'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Subuh',
                    timeText: widget.subuh,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_sunny_16_regular,
                    buttonColor: currentWaktuSolat == 'Zohor'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: currentWaktuSolat == 'Zohor'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Zohor',
                    timeText: widget.zohor,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_sunny_high_48_regular,
                    buttonColor: currentWaktuSolat == 'Asar'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: currentWaktuSolat == 'Asar'
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
                    buttonColor: currentWaktuSolat == 'Maghrib'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: currentWaktuSolat == 'Maghrib'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Maghrib',
                    timeText: widget.maghrib,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_moon_16_regular,
                    buttonColor: currentWaktuSolat == 'Isyak'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: currentWaktuSolat == 'Isyak'
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
