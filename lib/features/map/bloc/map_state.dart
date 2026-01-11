part of 'map_bloc.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final MosqueListModel mosques;
  MapLoaded({required this.mosques});
}

class MapError extends MapState {
  final String error;
  MapError({required this.error});
}

class MapMarkerTapped extends MapLoaded {
  final MosqueModel mosque;
  final String distance;
  final LatLng userLocation;
  MapMarkerTapped({
    required this.mosque,
    required this.distance,
    required this.userLocation,
    required super.mosques,
  });
}

class MapTapped extends MapLoaded {
  final List<Marker> pinList;
  MapTapped({required this.pinList, required super.mosques});
}
