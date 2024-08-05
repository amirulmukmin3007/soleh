import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:soleh/provider/mosque_marker_provider.dart';

class LeafletFunction {
  Map<String, dynamic> getMarkerInfo(
      MosqueMarkerProvider mosqueMarkerProvider, Marker marker) {
    String key = (marker.key as ValueKey<String>).value;
    String refid = key.replaceAll(RegExp(r"[<>'\[\]]"), '');
    Map<String, dynamic> result = {};

    mosqueMarkerProvider.markersInfo.forEach((element) {
      if (element['refid'] == refid) {
        result = element;
      } else {
        result = {};
      }
    });

    return result;
  }
}
