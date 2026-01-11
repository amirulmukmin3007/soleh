part of 'map_bloc.dart';

abstract class MapEvent {}

class MapInitialEvent extends MapEvent {}

class MapUpdateUserLocationEvent extends MapEvent {
  final double lat;
  final double lng;
  MapUpdateUserLocationEvent({required this.lat, required this.lng});
}

class MapTapMarkerEvent extends MapEvent {
  final String refId;
  MapTapMarkerEvent({required this.refId});
}

class MapTapEvent extends MapEvent {
  final LatLng point;
  MapTapEvent({required this.point});
}

class MapSearchLocationEvent extends MapEvent {
  final String location;
  MapSearchLocationEvent({required this.location});
}

class MapClickSearchLocationEvent extends MapEvent {
  final LatLng location;
  MapClickSearchLocationEvent({required this.location});
}

class MapTapSearchBarEvent extends MapEvent {}
