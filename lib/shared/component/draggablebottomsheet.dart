import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:soleh/model/map_model.dart';
import 'package:soleh/shared/component/infobar.dart';
import 'package:soleh/themes/fonts.dart';
import 'package:simple_icons/simple_icons.dart';

class DraggableSheet extends StatefulWidget {
  const DraggableSheet({
    super.key,
    required this.sheetController,
    required this.locationNameLarge,
    required this.locationNameSmall,

    // For Masjid only
    required this.masjidFlag,
    required this.serviceType,
    required this.businessHours,
    required this.lat,
    required this.long,
    required this.distance,

    // Current Lat Long
    required this.currentLat,
    required this.currentLong,
  });

  final DraggableScrollableController sheetController;
  final String locationNameLarge;
  final String locationNameSmall;
  final bool masjidFlag;

  final String serviceType;
  final String businessHours;
  final String lat;
  final String long;
  final String distance;

  final String currentLat;
  final String currentLong;

  @override
  _DraggableSheetState createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  FontTheme fontTheme = FontTheme();
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0,
      maxChildSize: 0.6,
      minChildSize: 0,
      expand: true,
      snap: true,
      snapSizes: const [0.2],
      controller: widget.sheetController,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.locationNameLarge,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: fontTheme.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.locationNameSmall,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 170, 170, 170)),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: widget.masjidFlag,
                        child: Row(
                          children: [
                            const Icon(
                              FluentIcons.vehicle_car_20_filled,
                              color: Color.fromARGB(255, 120, 120, 120),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${widget.distance} km",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 120, 120, 120),
                                fontFamily: fontTheme.fontFamily,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: widget.masjidFlag,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(icon: Icon(FluentIcons.location_16_filled)),
                              Tab(icon: Icon(FluentIcons.directions_16_filled)),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        InfoBar(
                                          textDisplay: widget.serviceType,
                                          icon: FluentIcons.handshake_16_filled,
                                          iconBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 200, 180, 255),
                                          iconColor: const Color(0xFF6750a4),
                                        ),
                                        const SizedBox(height: 10),
                                        InfoBar(
                                          textDisplay: widget.businessHours,
                                          icon: FluentIcons.clock_16_filled,
                                          iconBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 200, 180, 255),
                                          iconColor: const Color(0xFF6750a4),
                                        ),
                                        const SizedBox(height: 10),
                                        InfoBar(
                                          textDisplay:
                                              '${widget.lat}, ${widget.long}',
                                          icon: FluentIcons
                                              .location_arrow_16_filled,
                                          iconBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 200, 180, 255),
                                          iconColor: const Color(0xFF6750a4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        InfoBarClickable(
                                          function: () {
                                            MapModel().openNavigationURL(
                                              'waze',
                                              widget.currentLat,
                                              widget.currentLong,
                                              widget.lat,
                                              widget.long,
                                            );
                                          },
                                          textDisplay:
                                              'Go to Location using Waze',
                                          icon: SimpleIcons.waze,
                                          iconBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 189, 239, 255),
                                          iconColor: const Color(0xFF33CCFF),
                                        ),
                                        const SizedBox(height: 10),
                                        InfoBarClickable(
                                          function: () {
                                            MapModel().openNavigationURL(
                                              'googlemaps',
                                              widget.currentLat,
                                              widget.currentLong,
                                              widget.lat,
                                              widget.long,
                                            );
                                          },
                                          textDisplay:
                                              'Go to Location using Google Maps',
                                          icon: SimpleIcons.googlemaps,
                                          iconBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 208, 246, 208),
                                          iconColor: const Color.fromARGB(
                                              255, 88, 167, 81),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}