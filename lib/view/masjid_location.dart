import 'dart:async';
import 'dart:isolate';

import 'package:accordion/accordion.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/model/home_model.dart';
import 'package:soleh/model/map_model.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/component/alertdialog.dart';
import 'package:soleh/shared/component/clustercircle.dart';
import 'package:soleh/shared/component/draggablebottomsheet.dart';
import 'package:soleh/shared/component/legend.dart';
import 'package:soleh/shared/component/searchbar.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class MasjidLocation extends StatefulWidget {
  static const routeName = '/masjid_location';
  const MasjidLocation({super.key});

  @override
  State<MasjidLocation> createState() => _MasjidLocationState();
}

class _MasjidLocationState extends State<MasjidLocation> {
  late MapModel mapModel;
  HomeModel homeModel = HomeModel();
  Formatter formatter = Formatter();
  final FontTheme fontTheme = FontTheme();

  final GlobalKey<ScaffoldState> leafletScaffoldKey =
      GlobalKey<ScaffoldState>();
  bool googleSearchListFlag = false;
  bool masjidSearchListFlag = false;
  TextEditingController searchControllerGoogle = TextEditingController();
  TextEditingController searchControllerPoi = TextEditingController();

  @override
  void initState() {
    super.initState();
    mapModel = MapModel();
    mapModel.parentClusterMarkers = [];
    mapModel.initState(context);
    mapModel.textController ??= TextEditingController();
    mapModel.getDatapoints().then((value) {
      setState(() {
        ClusterMarkersDataPacket markersData = value;
        mapModel.parentClusterMarkers = markersData.markers;
        mapModel.parentClusterMarkersInfo = markersData.markersInfo;
        print("total " + mapModel.parentClusterMarkers.length.toString());
      });
    });
    // _mapBackgroundTask();
  }

  // void _mapBackgroundTask() async {
  //   ReceivePort receivePort = ReceivePort();
  //   Isolate? isolate =
  //       await Isolate.spawn(mapModel.getDatapoints, receivePort.sendPort);

  //   // Listen for data sent from the isolate
  //   receivePort.listen((data) {
  //     if (data is ClusterMarkersDataPacket) {
  //       setState(() {
  //         mapModel.parentClusterMarkers = data.markers;
  //         mapModel.parentClusterMarkersInfo = data.markersInfo;
  //         mapModel.clusterFlag = data.clusterFlag;

  //         print("total " + mapModel.parentClusterMarkers.length.toString());
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    mapModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: leafletScaffoldKey,
      drawer: GestureDetector(
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
          });
        },
        child: Drawer(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorTheme.primary,
                          width: 2.0,
                        ),
                      ),
                      child: RawMaterialButton(
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          FluentIcons.filter_16_filled,
                          color: ColorTheme.primary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchBarMasjid(
                        search: (String value) {},
                        onTap: () {
                          setState(() {
                            masjidSearchListFlag = true;
                          });
                        },
                        onChanged: (String value) {
                          setState(() {
                            masjidSearchListFlag = true;
                            searchControllerPoi.text = value;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            masjidSearchListFlag = false;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        back: () {
                          setState(() {
                            masjidSearchListFlag = false;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        masjidSearchListFlag: masjidSearchListFlag,
                        controller: searchControllerPoi,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: masjidSearchListFlag,
                child: Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: mapModel.getMasjid(searchControllerPoi.text),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 200,
                              width: 200,
                              child: Image(
                                image: AssetImage(
                                  'assets/images/no-internet.png',
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'No internet connection.',
                                style: TextStyle(
                                  fontFamily: FontTheme().fontFamily,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 200,
                              width: 200,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/travel-location.png'),
                              ),
                            ),
                            Center(
                              child: Text(
                                'No POI found.',
                                style: TextStyle(
                                  fontFamily: FontTheme().fontFamily,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        List<dynamic>? data = snapshot.data;
                        return ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            String service_provider =
                                data[index]['service_provider'];
                            String address = data[index]['address'];
                            return MasjidListTile(
                              masjid: data[index],
                              location: "[$service_provider] $address",
                              serviceType: data[index]['service_type'],
                              press: (value) {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  googleSearchListFlag = false;

                                  var masjidLat = value['lat'];
                                  var masjidLng = value['lng'];

                                  mapModel.masjidFlag = true;
                                  mapModel.dragLocationNameLarge =
                                      value['place'].toString();
                                  mapModel.dragLocationNameSmall =
                                      value['address'].toString();
                                  mapModel.dragDistrict =
                                      value['district'].toString();
                                  mapModel.dragNoTel =
                                      value['no_tel'].toString();
                                  mapModel.dragLat = value['lat'].toString();
                                  mapModel.dragLong = value['lng'].toString();
                                  mapModel.dragDistance =
                                      mapModel.calculateDistance(
                                          homeModel.currentLat,
                                          homeModel.currentLng,
                                          double.parse(value['lat']),
                                          double.parse(value['lng']));
                                  mapModel.moveCameraToMasjid(
                                    LatLng(
                                      double.parse(masjidLat),
                                      double.parse(masjidLng),
                                    ),
                                  );
                                  mapModel.expandDraggableSheet();

                                  leafletScaffoldKey.currentState
                                      ?.closeDrawer();
                                });
                              },
                            );
                          },
                        );
                      } else {
                        return const Text('No data yet.');
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Accordion(
                  children: [
                    AccordionSection(
                      headerBackgroundColor: ColorTheme.primary,
                      header: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Location Listing",
                          style: TextStyle(
                            fontFamily: fontTheme.fontFamily,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      content: Container(),
                    ),
                    AccordionSection(
                      headerBackgroundColor: ColorTheme.primary,
                      header: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Legend",
                          style: TextStyle(
                            fontFamily: fontTheme.fontFamily,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      content: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => mapModel.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(mapModel.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: googleSearchListFlag == false ||
                  homeModel.currentLocation == null
              ? SpeedDial(
                  animatedIcon: AnimatedIcons.list_view,
                  animatedIconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  backgroundColor: ColorTheme.primary,
                  foregroundColor: Colors.grey,
                  visible: true,
                  curve: Curves.bounceIn,
                  children: [
                      SpeedDialChild(
                        child: const Icon(FluentIcons.my_location_16_regular),
                        onTap: () {
                          setState(() {
                            print(mapModel.parentClusterMarkers);
                            googleSearchListFlag = false;
                            LatLng location = LatLng(
                                homeModel.currentLat, homeModel.currentLng);
                            mapModel.moveCameraToLocation(location);
                          });
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(FluentIcons.radar_20_filled),
                        onTap: () {
                          setState(() {
                            googleSearchListFlag = false;

                            if (mapModel.onTapMarkerPinList.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (builder) => RadiusPopupInput(
                                  radiusTypeList: mapModel.radiusType,
                                  selectedRadiusType:
                                      mapModel.selectedRadiusType,
                                  radiusController: mapModel.radiusController,
                                  widget: DropdownButton<String>(
                                    value: mapModel.selectedRadiusType,
                                    items:
                                        mapModel.radiusType.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        mapModel.selectedRadiusType = newValue!;
                                      });
                                    },
                                  ),
                                  onPressed: () {
                                    mapModel.radiusFlag = true;
                                    mapModel.setRadius(
                                        mapModel.onTapLat,
                                        mapModel.onTapLong,
                                        mapModel.radiusController.text);
                                    Navigator.pop(context);
                                    FocusScope.of(context).unfocus();
                                  },
                                  radiusFlag: mapModel.radiusFlag,
                                  reset: () {
                                    mapModel.radiusFlag = false;
                                    mapModel.radiusCircleList = [];
                                    mapModel.radiusController.clear();
                                    Navigator.pop(context);
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              );
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (builder) =>
                                      const RadiusPopupAlert());
                            }
                            // mapModel.setRadius(mapModel.onTapLat, mapModel.onTapLong, 1000.00);
                          });
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(FluentIcons.globe_28_regular),
                        onTap: () {
                          googleSearchListFlag = false;
                          mapModel.malaysiaBirdView();
                        },
                      ),
                    ])
              : null,
          backgroundColor: Colors.transparent,
          body: homeModel.currentLat == 0.0 && homeModel.currentLng == 0.0
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialZoom: 7,
                          initialCenter: LatLng(
                              homeModel.currentLat, homeModel.currentLng),
                          onTap: (tapPosition, masjidnt) {
                            setState(() {
                              mapModel.onTapMarkerFlag = true;
                              mapModel.onTapLat = masjidnt.latitude;
                              mapModel.onTapLong = masjidnt.longitude;
                              if (mapModel.radiusCircleList.isNotEmpty) {
                                mapModel.radiusFlag = true;
                                mapModel.setRadius(
                                  mapModel.onTapLat,
                                  mapModel.onTapLong,
                                  mapModel.radiusController.text,
                                );
                              }

                              mapModel.onTapMarker(masjidnt);
                              mapModel.dragLocationNameLarge =
                                  '${masjidnt.latitude}, ${masjidnt.longitude}';
                              mapModel.dragLocationNameSmall =
                                  'Latitude and Longitude';
                              mapModel.masjidFlag = false;

                              mapModel.dragDistrict = '';
                              mapModel.dragNoTel = '';
                              mapModel.dragLat = '';
                              mapModel.dragLong = '';
                            });
                            mapModel.expandDraggableSheet();
                          },
                          onPositionChanged: (MapPosition position, _) {
                            mapModel.collapseDraggableSheet();
                          },
                        ),
                        mapController: mapModel.mapController,
                        children: [
                          TileLayer(
                            urlTemplate:
                                // "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                "https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}&key=$googleMapKey",
                            userAgentPackageName: 'com.example.app',
                          ),
                          CurrentLocationLayer(
                            style: const LocationMarkerStyle(
                              marker: DefaultLocationMarker(),
                              markerSize: Size(20, 20),
                            ),
                          ),
                          MarkerClusterLayerWidget(
                            options: MarkerClusterLayerOptions(
                              markers: mapModel.parentClusterMarkers,
                              maxClusterRadius: 100,
                              size: const Size(40, 40),
                              polygonOptions: const PolygonOptions(
                                borderColor: Colors.transparent,
                                color: Colors.black12,
                                borderStrokeWidth: 3,
                              ),
                              builder: (context, parentClusterMarkers) {
                                return ClusterCircle(
                                  numericValue:
                                      parentClusterMarkers.length.toString(),
                                );
                              },
                              onMarkerTap: ((value) {
                                setState(() {
                                  String key = (value.key as Key).toString();
                                  String refid =
                                      key.replaceAll(RegExp(r"[<>'\[\]]"), '');
                                  Map<String, dynamic> masjidnt =
                                      mapModel.getRangkaianInfo(refid);
                                  mapModel.masjidFlag = true;
                                  mapModel.dragLocationNameLarge =
                                      masjidnt['location_name'].toString();
                                  mapModel.dragLocationNameSmall =
                                      masjidnt['address'].toString();
                                  mapModel.dragDistrict =
                                      masjidnt['service_type'].toString();
                                  mapModel.dragNoTel =
                                      masjidnt['business_hours'].toString();
                                  mapModel.dragLat = masjidnt['lat'].toString();
                                  mapModel.dragLong =
                                      masjidnt['lng'].toString();
                                  mapModel.dragDistance =
                                      mapModel.calculateDistance(
                                          homeModel.currentLat,
                                          homeModel.currentLng,
                                          double.parse(masjidnt['lat']),
                                          double.parse(masjidnt['lng']));
                                  mapModel.expandDraggableSheet();
                                });
                              }),
                            ),
                          ),
                          MarkerLayer(
                            markers: mapModel.onTapMarkerPinList,
                          ),
                          CircleLayer(
                            circles: mapModel.radiusCircleList,
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          DraggableSheet(
                            sheetController: mapModel.dragController,
                            locationNameLarge: mapModel.dragLocationNameLarge,
                            locationNameSmall: mapModel.dragLocationNameSmall,
                            masjidFlag: mapModel.masjidFlag,
                            serviceType: mapModel.dragDistrict,
                            businessHours: mapModel.dragNoTel,
                            lat: mapModel.dragLat,
                            long: mapModel.dragLong,
                            distance: mapModel.dragDistance,
                            currentLat: homeModel.currentLat.toString(),
                            currentLong: homeModel.currentLng.toString(),
                          ),
                          Visibility(
                            visible: googleSearchListFlag,
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 80.0),
                                child: FutureBuilder<List<dynamic>>(
                                  future: mapModel.placeAutoCompleteSearch(
                                      searchControllerGoogle.text),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Align(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/images/no-internet.png',
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'No internet connection.',
                                              style: TextStyle(
                                                fontFamily:
                                                    FontTheme().fontFamily,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.hasData &&
                                        snapshot.data!.isEmpty) {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/travel-location.png'),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'No location found.',
                                              style: TextStyle(
                                                fontFamily:
                                                    FontTheme().fontFamily,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.hasData) {
                                      List<dynamic>? data = snapshot.data;
                                      return ListView.builder(
                                        itemCount: data!.length,
                                        itemBuilder: (context, index) {
                                          return LocationListTile(
                                            location: data[index],
                                            press: (value) async {
                                              setState(() {
                                                print(value);
                                                List<String> arrayLocationName =
                                                    formatter
                                                        .splitAddressAtFirstComma(
                                                            value);
                                                mapModel.dragLocationNameLarge =
                                                    arrayLocationName[0];
                                                mapModel.dragLocationNameSmall =
                                                    arrayLocationName[1];
                                                mapModel.masjidFlag = false;
                                                mapModel.dragDistrict = '';
                                                mapModel.dragNoTel = '';
                                                mapModel.dragLat = '';
                                                mapModel.dragLong = '';
                                                searchControllerGoogle.text =
                                                    value;
                                                googleSearchListFlag = false;
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                              var place = await mapModel
                                                  .getPlace(value);
                                              var masjidntLatLng =
                                                  await mapModel
                                                      .pointToPlace(place);
                                              mapModel.moveCameraToLocation(
                                                  masjidntLatLng);
                                              mapModel.expandDraggableSheet();
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      return const Text('No data yet.');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: RawMaterialButton(
                                          elevation:
                                              googleSearchListFlag ? 0 : 8,
                                          fillColor: Colors.white,
                                          padding: const EdgeInsets.all(15.0),
                                          shape: const CircleBorder(),
                                          child: const Icon(
                                            FluentIcons.list_16_filled,
                                            color: ColorTheme.primary,
                                          ),
                                          onPressed: () {
                                            // Scaffold.of(context).openDrawer()
                                            leafletScaffoldKey.currentState
                                                ?.openDrawer();
                                            FocusScope.of(context).requestFocus(
                                                mapModel.unfocusNode);
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: SearchBarMap(
                                            controller: searchControllerGoogle,
                                            googleSearchListFlag:
                                                googleSearchListFlag,
                                            onTap: () {
                                              setState(() {
                                                googleSearchListFlag = true;
                                              });
                                            },
                                            back: () {
                                              setState(() {
                                                googleSearchListFlag = false;
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                // Autocomplete search
                                                mapModel
                                                    .placeAutoCompleteSearch(
                                                        value);
                                              });
                                            },
                                            onEditingComplete: () {
                                              setState(() {
                                                googleSearchListFlag = false;
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                            search: (value) async {
                                              if (kDebugMode) {
                                                print(value);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                googleSearchListFlag == false
                                    ? Visibility(
                                        visible: mapModel.onTapMarkerFlag,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                          ),
                                          child: RawMaterialButton(
                                            elevation: 8.0,
                                            fillColor: Colors.white,
                                            padding: const EdgeInsets.all(15.0),
                                            shape: const CircleBorder(),
                                            child: Icon(
                                              FluentIcons
                                                  .location_off_16_filled,
                                              color: Colors.red[400],
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                googleSearchListFlag = false;
                                                mapModel.onTapMarkerFlag =
                                                    false;
                                                mapModel.onTapMarkerPinList =
                                                    [];
                                                mapModel
                                                    .collapseDraggableSheet();
                                                mapModel.dragLocationNameLarge =
                                                    '';
                                                mapModel.dragLocationNameSmall =
                                                    '';

                                                if (mapModel.radiusFlag) {
                                                  mapModel.radiusFlag = false;
                                                  mapModel.radiusCircleList =
                                                      [];
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
    ;
  }
}
