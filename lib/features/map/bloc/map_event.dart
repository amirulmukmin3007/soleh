part of 'map_bloc.dart';

abstract class MapEvent {}

class MapInitialEvent extends MapEvent {}

class MapSearchLocationEvent extends MapEvent {
  final String location;
  MapSearchLocationEvent({required this.location});
}

class MapClickSearchLocationEvent extends MapEvent {
  final LatLng location;
  MapClickSearchLocationEvent({required this.location});
}

class MapTapMosqueMarkerEvent extends MapEvent {
  final MosqueModel mosque;
  MapTapMosqueMarkerEvent({required this.mosque});
}
