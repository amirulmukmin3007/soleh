import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:location/location.dart';
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
  MapController mapController = MapController();
  LocationData pinMyLocation = LocationData.fromMap({});

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
    callGetLiveLocation();
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
              mapController: mapController,
              options: MapOptions(
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
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
                    showPolygon: false,
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
                      });

                      // Wait for the widget to rebuild before expanding sheet
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _expandDraggableSheet();
                      });
                    },
                  ),
                ),
                MarkerLayer(
                  markers: mapModel.onTapMarkerPinList,
                ),
              ],
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
            Visibility(
              visible: searchBarMapFlag,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Search Header with improved spacing
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  searchBarMapFlag = false;
                                  focusNode.unfocus();
                                });
                              },
                              icon: const Icon(Icons.arrow_back_ios, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Search Places',
                                style: TextStyle(
                                  fontFamily: FontTheme().fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Search Results Content
                      Expanded(
                        child: FutureBuilder<List<dynamic>>(
                          future: mapModel.placeAutoCompleteSearch(
                              searchBarMapController.text),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingState();
                            } else if (snapshot.hasError) {
                              return _buildErrorState();
                            } else if (snapshot.hasData &&
                                snapshot.data!.isEmpty) {
                              return _buildEmptyState();
                            } else if (snapshot.hasData) {
                              return _buildSearchResults(snapshot.data!);
                            } else {
                              return _buildEmptyState();
                            }
                          },
                        ),
                      ),
                    ],
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SpeedDial(
                    icon: FluentIcons.map_20_regular,
                    iconTheme: const IconThemeData(color: Colors.white),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorTheme.primary,
                        ColorTheme.primary.withValues(alpha: 0.75),
                      ],
                    ),
                    gradientBoxShape: BoxShape.circle,
                    visible: true,
                    curve: Curves.bounceIn,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.5,
                    children: [
                      SpeedDialChild(
                        label: 'My Location',
                        labelBackgroundColor: ColorTheme.primary,
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: FontTheme().fontFamily,
                        ),
                        shape: const CircleBorder(),
                        child: const Icon(FluentIcons.my_location_20_filled),
                        onTap: () {
                          _goToMyLocation();
                        },
                      ),
                      SpeedDialChild(
                        label: 'Malaysia View',
                        labelBackgroundColor: ColorTheme.primary,
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: FontTheme().fontFamily,
                        ),
                        shape: const CircleBorder(),
                        child: const Icon(FluentIcons.globe_20_filled),
                        onTap: () {
                          _goToMalaysiaView();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Functions
  Future<void> callGetMosqueMarker() async {
    await mapModel.getMosqueMarker(mosqueMarkerProvider);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> callGetLiveLocation() async {
    pinMyLocation = await homeModel.getLiveLocation(locationProvider);
    if (mounted) {
      setState(() {});
    }
  }

  void onMarkerTapDraggableSheet(Marker marker) {
    clearDraggableSheet();
    String key = (marker.key as ValueKey<String>).value;
    String refid = key.replaceAll(RegExp(r"[<>'\[\]]"), '');
    Map<String, dynamic> result = {};

    for (var element in mosqueMarkerProvider.markersInfo) {
      if (element['refid'] == int.parse(refid)) {
        result = element;
      }
    }

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

  void clearDraggableSheet() {
    mosqueMarkerFlag = false;
    placeDraggableSheet = '';
    addressDraggableSheet = '';
    stateDraggableSheet = '';
    poskodDraggableSheet = '';
    noTelDraggableSheet = '';
    latitudeDraggableSheet = '';
    longitudeDraggableSheet = '';
    distanceDraggableSheet = '';
  }

  // Safe method to expand draggable sheet
  void _expandDraggableSheet() {
    if (mounted && mapModel.dragController.isAttached) {
      try {
        mapModel.expandDraggableSheet();
      } catch (e) {
        // If it still fails, try again after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && mapModel.dragController.isAttached) {
            try {
              mapModel.expandDraggableSheet();
            } catch (e) {
              if (kDebugMode) {
                print('Failed to expand draggable sheet: $e');
              }
            }
          }
        });
      }
    }
  }

  // Safe method to go to my location
  void _goToMyLocation() {
    try {
      mapModel.goToMyLocation(
        context,
        mapController,
        pinMyLocation.latitude,
        pinMyLocation.longitude,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to go to my location: $e');
      }
    }
  }

  // Safe method to go to Malaysia view
  void _goToMalaysiaView() {
    try {
      // Add your Malaysia view logic here
      mapController.move(mapModel.defaultLatLng, 7);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to go to Malaysia view: $e');
      }
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    searchBarMapController.dispose();
    super.dispose();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: ColorTheme.primary,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Searching...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontFamily: FontTheme().fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                fontFamily: FontTheme().fontFamily,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  // Trigger rebuild to retry search
                });
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_searching_rounded,
                size: 48,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Results Found',
              style: TextStyle(
                fontFamily: FontTheme().fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchBarMapController.text.isEmpty
                  ? 'Start typing to search for places'
                  : 'Try a different search term',
              style: TextStyle(
                fontFamily: FontTheme().fontFamily,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '${data.length} result${data.length == 1 ? '' : 's'} found',
            style: TextStyle(
              fontFamily: FontTheme().fontFamily,
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Search results list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: data.length,
            separatorBuilder: (context, index) => const Divider(
              height: 0.5,
              thickness: 0.5,
              color: Colors.grey,
              indent: 48,
            ),
            itemBuilder: (context, index) {
              return LocationListTile(
                location: data[index],
                press: (value) async {
                  setState(() {
                    // Filtering Location Name
                    clearDraggableSheet();

                    List<String> arrayLocationName =
                        formatter.splitAddressAtFirstComma(value);
                    placeDraggableSheet = arrayLocationName[0];
                    addressDraggableSheet = arrayLocationName[1];

                    searchBarMapFlag = false;
                    focusNode.unfocus();
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
