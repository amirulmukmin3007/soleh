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
    final mosques = await repository.getMosqueMarker();

    MosqueModel mosqueModel;
    MosqueListModel mosquesList =
        MosqueListModel(mosques: []); // Initialize here

    for (var mosque in mosques) {
      mosqueModel = MosqueModel(
        name: mosque['name'],
        place: mosque['place'],
        address: mosque['address'],
        postcode: mosque['postcode'],
        district: mosque['district'],
        noTel: mosque['no_tel'],
        noFax: mosque['no_fax'],
        lat: mosque['lat'],
        lng: mosque['lng'],
        marker: Marker(
          key: Key(mosque['refid'].toString()),
          width: 40.0,
          height: 40.0,
          point: LatLng(mosque['lat'], mosque['lng']),
          child: Image.asset('assets/images/mosque_marker.png'),
        ),
      );

      mosquesList.mosques.add(mosqueModel);
    }

    emit(MapLoaded(mosques: mosquesList));
  }

  Future<void> tapMosqueMarker(
      MapTapMosqueMarkerEvent event, Emitter<MapState> emit) async {}
}
