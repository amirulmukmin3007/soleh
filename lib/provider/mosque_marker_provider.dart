import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MosqueMarkerProvider extends ChangeNotifier {
  List<Marker> _markers = [];
  List<Map<String, dynamic>> _markersInfo = [];
  bool _markersFlag = false;

  List<Marker> get markers => _markers;
  List<Map<String, dynamic>> get markersInfo => _markersInfo;
  bool get markersFlag => _markersFlag;

  void updateMarkers(List<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

  void updateMarkersInfo(List<Map<String, dynamic>> markersInfo) {
    _markersInfo = markersInfo;
    notifyListeners();
  }

  void updateMarkersFlag(bool markersFlag) {
    _markersFlag = markersFlag;
    notifyListeners();
  }
}
