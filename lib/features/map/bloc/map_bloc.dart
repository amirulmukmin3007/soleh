import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/features/map/models/mosque.dart';
import 'package:soleh/features/map/repositories/map_repository.dart';
import 'package:soleh/shared/component/draggablebottomsheet.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository repository;
  MosqueListModel? _cachedMosques;
  DraggableScrollableController sheetController =
      DraggableScrollableController();
  List<Marker>? pinList = [];
  double? currentLat;
  double? currentLng;

  MapBloc({required this.repository}) : super(MapInitial()) {
    on<MapInitialEvent>(loadMap);
    on<MapUpdateUserLocationEvent>(updateUserLocation);

    // Tapping
    on<MapTapMarkerEvent>(tapMosqueMarker);
    on<MapTapEvent>(tapMap);

    // Searching
    // on<MapTapSearchBarEvent>(tapSearchBar);
  }

  Future<void> loadMap(MapInitialEvent event, Emitter<MapState> emit) async {
    emit(MapLoading());

    if (_cachedMosques != null && _cachedMosques!.mosques.isNotEmpty) {
      emit(MapLoaded(mosques: _cachedMosques!));
      return;
    }

    try {
      _cachedMosques = await repository.getMosqueMarkers();

      emit(MapLoaded(mosques: _cachedMosques!));
    } catch (e, stackTrace) {
      print('Stack trace: $stackTrace');
      emit(MapError(error: e.toString()));
    }
  }

  Future<void> updateUserLocation(
      MapUpdateUserLocationEvent event, Emitter<MapState> emit) async {
    currentLat = event.lat;
    currentLng = event.lng;
  }

  void tapMosqueMarker(MapTapMarkerEvent event, Emitter<MapState> emit) {
    final refId = event.refId;
    MosqueModel mosque =
        _cachedMosques!.mosques.firstWhere((mosque) => mosque.refid == refId);

    String distance =
        calculateDistance(currentLat, currentLng, mosque.lat, mosque.lng);

    emit(MapMarkerTapped(
      mosque: mosque,
      distance: distance,
      userLocation: LatLng(currentLat!, currentLng!),
      mosques: _cachedMosques!,
    ));
  }

  void tapMap(MapTapEvent event, Emitter<MapState> emit) {
    if (pinList != null) {
      pinList!.clear();
    }

    Marker marker = Marker(
      point: event.point,
      child: Transform.translate(
        offset: const Offset(-5, -20),
        child: const Icon(
          size: 40,
          Icons.location_on,
          color: Color.fromARGB(255, 220, 64, 61),
        ),
      ),
    );
    pinList!.add(marker);

    emit(MapTapped(pinList: pinList!, mosques: _cachedMosques!));
  }

  // void tapSearchBar(
  //     MapTapSearchBarEvent event, Emitter<MapState> emit) {
  //   emit(MapSearchBarTapped(mosques: _cachedMosques!));
  //   return Future.value();
  // }

  String calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var distance = 12742 * asin(sqrt(a));
    distance = double.parse((distance).toStringAsFixed(2));
    String formattedDistance = NumberFormat.decimalPattern().format(distance);
    return formattedDistance;
  }
}
