import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:simple_icons/simple_icons.dart';

import 'package:soleh/model/masjid_location_model.dart';
import 'package:soleh/shared/component/infobar.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class DraggableSheet extends StatefulWidget {
  const DraggableSheet({
    super.key,
    required this.sheetController,
    required this.place,
    required this.address,
    required this.mosqueFlag,
    required this.state,
    required this.poskod,
    required this.lat,
    required this.long,
    required this.distance,
    required this.currentLat,
    required this.currentLong,
  });

  final DraggableScrollableController sheetController;
  final String place;
  final String address;
  final bool mosqueFlag;
  final String state;
  final String poskod;
  final String lat;
  final String long;
  final String distance;
  final String currentLat;
  final String currentLong;

  @override
  DraggableSheetState createState() => DraggableSheetState();
}

class DraggableSheetState extends State<DraggableSheet> {
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: widget.mosqueFlag
              ? DefaultTabController(
                  length: 2,
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 5,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              Text(
                                widget.place,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: FontTheme().fontFamily,
                                ),
                              ),
                              Text(
                                widget.address,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: FontTheme().fontFamily,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: widget.mosqueFlag,
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
                                        color:
                                            Color.fromARGB(255, 120, 120, 120),
                                        fontFamily: FontTheme().fontFamily,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _StickyTabBarDelegate(
                          TabBar(
                            indicatorColor: ColorTheme.primary,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: ColorTheme.primary,
                            labelStyle: TextStyle(
                              fontFamily: FontTheme().fontFamily,
                            ),
                            tabs: const [
                              Tab(
                                  icon: Icon(FluentIcons.location_16_filled),
                                  text: "Mosque"),
                              Tab(
                                  icon: Icon(FluentIcons.directions_16_filled),
                                  text: "Direction"),
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                      SliverFillRemaining(
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      InfoBar(
                                        label: 'Mosque',
                                        textDisplay: widget.state,
                                        icon: Symbols.mosque_rounded,
                                      ),
                                      Divider(
                                        color: Colors.grey[200],
                                      ),
                                      const SizedBox(height: 10),
                                      InfoBar(
                                        label: 'Postcode',
                                        textDisplay: widget.poskod,
                                        icon:
                                            FluentIcons.street_sign_20_regular,
                                      ),
                                      Divider(
                                        color: Colors.grey[200],
                                      ),
                                      const SizedBox(height: 10),
                                      InfoBar(
                                        label: 'Location',
                                        textDisplay:
                                            '${widget.lat}, ${widget.long}',
                                        icon: FluentIcons
                                            .location_arrow_16_regular,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
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
                                      textDisplay: 'Go to Location using Waze',
                                      icon: SimpleIcons.waze,
                                      iconBackgroundColor: const Color.fromARGB(
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
                                      iconBackgroundColor: const Color.fromARGB(
                                          255, 208, 246, 208),
                                      iconColor: const Color.fromARGB(
                                          255, 88, 167, 81),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _StickyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
