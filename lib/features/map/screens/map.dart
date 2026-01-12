import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/features/home/bloc/home_bloc.dart';
import 'package:soleh/features/map/bloc/map_bloc.dart';
import 'package:soleh/features/map/config/draggable_sheet_controller.dart';
import 'package:soleh/features/map/config/map_controller.dart';
import 'package:soleh/features/map/models/mosque.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/component/clustercircle.dart';
import 'package:soleh/shared/component/draggablebottomsheet.dart';
import 'package:soleh/shared/component/searchbar.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  const MapScreen({super.key, required this.isActive});
  final bool isActive;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Formatter formatter;
  late DraggableSheetConfig draggableSheetConfig;
  late MapConfig mapConfig;
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController searchBarMapController = TextEditingController();
  DraggableScrollableController sheetController =
      DraggableScrollableController();
  MapController mapController = MapController();
  MosqueModel selectedMosque = MosqueModel.setNull();
  String currentDistance = '0.00';
  LatLng currentLocation = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    formatter = Formatter();
    draggableSheetConfig = DraggableSheetConfig();
    mapConfig = MapConfig();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    searchBarMapController.dispose();
    if (kDebugMode) {
      log('Map is Inactive');
    }
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      if (kDebugMode) {
        log('Map is Active');
      }
      _onActive();
    }
  }

  void _onActive() {
    context.read<MapBloc>().add(MapInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded) {
          context.read<MapBloc>().add(MapUpdateUserLocationEvent(
              lat: state.userLatitude, lng: state.userLongitude));
        }
      },
      child: BlocConsumer<MapBloc, MapState>(
        listener: (BuildContext context, MapState state) {
          if (state is MapMarkerTapped) {
            draggableSheetConfig.expandSheet(sheetController);
          }
          if (state is MapTapped) {
            draggableSheetConfig.collapseSheet(sheetController);
          }
        },
        builder: (BuildContext context, MapState state) {
          if (state is MapMarkerTapped) {
            currentDistance = state.distance;
            currentLocation = state.userLocation;
            selectedMosque = state.mosque;
          }
          if (state is MapTapped) {
            selectedMosque = MosqueModel.setNull();
          }

          return _displayMap(context, state);
        },
      ),
    );
  }

  Widget _displayMap(BuildContext context, MapState state) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {},
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
                initialZoom: 7,
                initialCenter: LatLng(3.14, 101.69),
                onTap: (tapPosition, point) {
                  context.read<MapBloc>().add(MapTapEvent(point: point));
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}&key=$googleMapKey",
                  userAgentPackageName: 'com.example.app',
                ),
                CurrentLocationLayer(
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(),
                    markerSize: Size(20, 20),
                  ),
                ),
                if (state is MapLoading)
                  const Center(child: CircularProgressIndicator()),
                if (state is MapLoaded)
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                        showPolygon: false,
                        markers: state.mosques.markers,
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
                          String trimKey =
                              (marker.key as ValueKey<String>).value;
                          String finalKey =
                              trimKey.replaceAll(RegExp(r"[<>'\[\]]"), '');
                          context.read<MapBloc>().add(
                                MapTapMarkerEvent(refId: finalKey),
                              );
                        }),
                  ),
                if (state is MapTapped)
                  MarkerLayer(
                    markers: state.pinList,
                  ),
              ],
            ),
            MarkerInfoSheet(
              sheetController: sheetController,
              mosque: selectedMosque,
              distance: currentDistance,
              userLocation: currentLocation,
            ),
            if (state is MapSearchBarTapped &&
                state is! MapUnfocusSearchBarEvent)
              Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
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
                                  // searchBarMapFlag = false;
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
                      if (state is MapSearchBarLoaded)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: Text(
                                  '${state.searchedResult.length} result${state.searchedResult.length == 1 ? '' : 's'} found',
                                  style: TextStyle(
                                    fontFamily: FontTheme().fontFamily,
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  itemCount: state.searchedResult.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    height: 0.5,
                                    thickness: 0.5,
                                    color: Colors.grey,
                                    indent: 48,
                                  ),
                                  itemBuilder: (context, index) {
                                    return LocationListTile(
                                      location: state.searchedResult[index],
                                      press: (value) async {},
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (state is MapSearchBarLoading)
                        Center(
                          child: CircularProgressIndicator(
                            color: ColorTheme.primary,
                          ),
                        )
                    ],
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
                        googleSearchListFlag: state is MapSearchBarTapped,
                        onTap: () =>
                            context.read<MapBloc>().add(MapTapSearchBarEvent()),
                        back: () => {
                          focusNode.unfocus(),
                          context
                              .read<MapBloc>()
                              .add(MapUnfocusSearchBarEvent())
                        },
                        onChanged: (value) {
                          context
                              .read<MapBloc>()
                              .add(MapInputSearchBarEvent(location: value));
                        },
                        onEditingComplete: () {
                          // searchBarMapFlag = false;
                          focusNode.unfocus();
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
                          mapConfig.goToMyLocation(
                            context,
                            mapController,
                            currentLocation.latitude,
                            currentLocation.longitude,
                          );
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
                          // _goToMalaysiaView();
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
}
