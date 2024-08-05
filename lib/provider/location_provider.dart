import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class LocationProvider extends ChangeNotifier {
  late LocationData _currentLocation;
  String _currentLocationName = '';
  double? _currentLongitude;
  double? _currentLatitude;

  LocationData get currentLocation => _currentLocation;
  String get currentLocationName => _currentLocationName;
  double? get currentLongitude => _currentLongitude;
  double? get currentLatitude => _currentLatitude;

  void updateLocation(
      LocationData location, double? latitude, double? longitude) {
    _currentLocation = location;
    _currentLongitude = longitude;
    _currentLatitude = latitude;
    notifyListeners();
  }

  void updateLocationName(String locationName) {
    _currentLocationName = locationName;
    notifyListeners();
  }
}
