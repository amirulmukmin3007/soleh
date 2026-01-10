import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/features/map/models/mosque.dart';
import 'package:soleh/features/map/repositories/map_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository repository;

  MapBloc({required this.repository}) : super(MapInitial()) {
    on<MapInitialEvent>(loadMap);
    // on<MapSearchLocationEvent>(searchLocation);
    // on<MapClickSearchLocationEvent>(clickSearchLocation);
    // on<MapTapMosqueMarkerEvent>(tapMosqueMarker);
  }

  Future<void> loadMap(MapInitialEvent event, Emitter<MapState> emit) async {
    emit(MapLoading());

    final mosquesList = await repository.getMosqueMarkers();

    emit(MapLoaded(mosques: mosquesList));
  }

  Future<void> tapMosqueMarker(
      MapTapMosqueMarkerEvent event, Emitter<MapState> emit) async {}
}
