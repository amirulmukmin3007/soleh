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

class MapSearchBarTapped extends MapLoaded {
  MapSearchBarTapped({required super.mosques});
}

class MapUnfocusedSearchBar extends MapLoaded {
  MapUnfocusedSearchBar({required super.mosques});
}

class MapSearchBarLoading extends MapSearchBarTapped {
  MapSearchBarLoading({required super.mosques});
}

class MapSearchBarLoaded extends MapSearchBarTapped {
  final List<dynamic> searchedResult;
  MapSearchBarLoaded({required this.searchedResult, required super.mosques});
}
