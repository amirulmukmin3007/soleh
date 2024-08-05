import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/model/map_model.dart';
import 'package:soleh/model/home_model.dart';
import 'package:soleh/provider/location_provider.dart';
import 'package:soleh/provider/mosque_marker_provider.dart';
import 'package:soleh/shared/component/clustercircle.dart';
import 'package:soleh/shared/component/draggablebottomsheet.dart';
import 'package:soleh/shared/component/searchbar.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:soleh/shared/functions/leaflet.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class MosqueMap extends StatefulWidget {
  static const routeName = '/map';
  const MosqueMap({super.key, required this.isActive});
  final bool isActive;

  @override
  State<MosqueMap> createState() => _MosqueMapState();
}

class _MosqueMapState extends State<MosqueMap> {
  late MosqueMarkerProvider mosqueMarkerProvider;
  late LocationProvider locationProvider;
  late MapModel mapModel;
  late HomeModel homeModel;
  late LeafletFunction leafletFunction;
  late Formatter formatter;
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Map
  TextEditingController searchBarMapController = TextEditingController();
  bool searchBarMapFlag = false;
  bool mosqueMarkerFlag = false;

  // Draggable Sheet
  String placeDraggableSheet = '';
  String addressDraggableSheet = '';
  String stateDraggableSheet = '';
  String poskodDraggableSheet = '';
  String noTelDraggableSheet = '';
  String latitudeDraggableSheet = '';
  String longitudeDraggableSheet = '';
  String distanceDraggableSheet = '';
  String currentLatDraggableSheet = '';
  String currentLngDraggableSheet = '';

  @override
  void initState() {
    super.initState();
    mosqueMarkerProvider = MosqueMarkerProvider();
    locationProvider = LocationProvider();
    mapModel = MapModel();
    homeModel = HomeModel();
    leafletFunction = LeafletFunction();
    formatter = Formatter();
    callGetMosqueMarker();
  }

  Future<void> callGetMosqueMarker() async {
    await mapModel.getMosqueMarker(mosqueMarkerProvider);
    setState(() {});
  }

  Future<void> callGetLiveLocation() async {
    await homeModel.getLiveLocation(locationProvider);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          setState(() {});
        },
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialZoom: 7,
                initialCenter: mapModel.defaultLatLng,
                onTap: (tapPosition, point) {
                  setState(() {
                    mapModel.onTapMarker(point);
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: mapModel.defaultMapTile,
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    markers: mosqueMarkerProvider.markers,
                    maxClusterRadius: 100,
                    size: const Size(40, 40),
                    polygonOptions: const PolygonOptions(
                      borderColor: Colors.transparent,
                      color: Colors.black12,
                      borderStrokeWidth: 3,
                    ),
                    builder: (context, markers) => ClusterCircle(
                      numericValue: markers.length.toString(),
                    ),
                    onMarkerTap: (marker) {
                      setState(() {
                        onMarkerTapDraggableSheet(marker);
                        mapModel.expandDraggableSheet();
                      });
                    },
                  ),
                ),
                MarkerLayer(
                  markers: mapModel.onTapMarkerPinList,
                ),
              ],
            ),
            Visibility(
              visible: searchBarMapFlag,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: FutureBuilder<List<dynamic>>(
                      future: mapModel
                          .placeAutoCompleteSearch(searchBarMapController.text),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                  color: ColorTheme.primary));
                        } else if (snapshot.hasError) {
                          return SingleChildScrollView(
                            child: Column(
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
                                      fontFamily: FontTheme().fontFamily,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return SingleChildScrollView(
                            child: Column(
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
                                    'No results found.',
                                    style: TextStyle(
                                      fontFamily: FontTheme().fontFamily,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        } else if (snapshot.hasData) {
                          List<dynamic>? data = snapshot.data;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              return LocationListTile(
                                location: data[index],
                                press: (value) async {
                                  setState(() {
                                    // Filtering Location Name
                                    List<String> arrayLocationName = formatter
                                        .splitAddressAtFirstComma(value);
                                    mapModel.dragLocationNameLarge =
                                        arrayLocationName[0];

                                    mapModel.dragLocationNameSmall =
                                        arrayLocationName[1];
                                    // -----------------------------------------------

                                    //   mapModel.poiFlag = leafletMapController
                                    //       .setFlagFalsePOIDraggableSheet(
                                    //           mapModel.poiFlag);

                                    //   mapModel.dragServiceType =
                                    //       leafletMapController
                                    //           .setDraggableSheetServiceType('');
                                    //   mapModel.dragBusinessHours =
                                    //       leafletMapController
                                    //           .setDraggableSheetBusinessHour('');
                                    //   mapModel.dragCategory = leafletMapController
                                    //       .setDraggableSheetCategory('');
                                    //   mapModel.dragLat =
                                    //       leafletMapController.setLatSBGM('');
                                    //   mapModel.dragLong =
                                    //       leafletMapController.setLatSBGM('');

                                    //   searchControllerGoogle.text = value;
                                    //   mapModel.googleSearchListFlag =
                                    //       leafletMapController.setFlagFalseSBGM(
                                    //           mapModel.googleSearchListFlag);
                                    //   FocusScope.of(context).unfocus();
                                  });
                                  // var place = await mapModel.getPlace(value);
                                  // var pointLatLng =
                                  //     await mapModel.pointToPlace(place);
                                  // mapModel.moveCameraToLocation(pointLatLng);
                                  // mapModel.expandDraggableSheet();
                                },
                              );
                            },
                          );
                        } else {
                          return const Text('Tiada data.');
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      child: SearchBarMap(
                        focusNode: focusNode,
                        controller: searchBarMapController,
                        googleSearchListFlag: searchBarMapFlag,
                        onTap: () {
                          setState(() {
                            searchBarMapFlag = true;
                          });
                        },
                        back: () {
                          setState(() {
                            searchBarMapFlag = false;
                            focusNode.unfocus();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            // Autocomplete search
                            mapModel.placeAutoCompleteSearch(value);
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            searchBarMapFlag = false;
                            focusNode.unfocus();
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
                ],
              ),
            ),
            DraggableSheet(
              sheetController: mapModel.dragController,
              place: placeDraggableSheet,
              address: addressDraggableSheet,
              mosqueFlag: mosqueMarkerFlag,
              state: stateDraggableSheet,
              poskod: poskodDraggableSheet,
              lat: latitudeDraggableSheet,
              long: longitudeDraggableSheet,
              distance: distanceDraggableSheet,
              currentLat: currentLatDraggableSheet,
              currentLong: currentLngDraggableSheet,
            ),
          ],
        ),
      ),
    );
  }

  // Functions
  void onMarkerTapDraggableSheet(Marker marker) {
    String key = (marker.key as ValueKey<String>).value;
    String refid = key.replaceAll(RegExp(r"[<>'\[\]]"), '');
    Map<String, dynamic> result = {};
    print(refid);

    mosqueMarkerProvider.markersInfo.forEach((element) {
      if (element['refid'] == int.parse(refid)) {
        result = element;
      }
    });

    if (result.isNotEmpty) {
      // Ensure that all required fields exist before using them
      placeDraggableSheet = result['place'] ?? 'Unknown Place';
      addressDraggableSheet = result['address'] ?? 'Unknown Address';
      stateDraggableSheet = result['state'] ?? 'Unknown State';
      poskodDraggableSheet = result['poskod']?.toString() ?? 'Unknown Postcode';
      noTelDraggableSheet = result['no_tel'] ?? 'Unknown Phone';
      latitudeDraggableSheet = result['lat']?.toString() ?? '0.0';
      longitudeDraggableSheet = result['lng']?.toString() ?? '0.0';
      currentLatDraggableSheet = locationProvider.currentLatitude.toString();
      currentLngDraggableSheet = locationProvider.currentLongitude.toString();
      mosqueMarkerFlag = true;

      double lat1 = locationProvider.currentLatitude ?? mapModel.defaultLat;
      double lon1 = locationProvider.currentLongitude ?? mapModel.defaultLng;

      double lat2 = double.tryParse(latitudeDraggableSheet) ?? 0.0;
      double lon2 = double.tryParse(longitudeDraggableSheet) ?? 0.0;

      distanceDraggableSheet =
          mapModel.calculateDistance(lat1, lon1, lat2, lon2);
    }
  }
}
