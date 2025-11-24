import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/provider/mosque_marker_provider.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;
import 'package:intl/intl.dart';
import 'package:soleh/shared/component/dialogs.dart';

class MapModel {
  LatLng defaultLatLng = const LatLng(3.14, 101.69);
  double defaultLat = 3.1421764850803244;
  double defaultLng = 101.69171438465744;
  String defaultMapTile =
      "https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}&key=$googleMapKey";
  String defaultMapTile2 =
      "https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}.png?key=oJo1lsj89BZ6R7OTxTm1";

  // On Tap State Management
  late Marker onTapMarkerPin =
      Marker(point: LatLng(defaultLat, defaultLng), child: Container());
  late double onTapLat;
  late double onTapLong;
  late List<Marker> onTapMarkerPinList = [];
  DraggableScrollableController dragController =
      DraggableScrollableController();

  // Searching
  Map<String, dynamic> placeList = {};
  List<dynamic> descriptionList = [];

  // Mosque Markers
  List<Marker> markerList = [];
  List<Map<String, dynamic>> markerListInfo = [];
  bool markerListFlag = false;

  void goToMyLocation(BuildContext context, MapController mapController,
      double? myLat, double? myLong) {
    if (myLat == null || myLong == null) {
      CustomDialog.show(context,
          title: 'Location Unavailable',
          description: 'Please enable location service',
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]);
    } else {
      mapController.move(LatLng(myLat, myLong), 15.0);
    }
  }

  void onTapMarker(LatLng point) {
    onTapMarkerPinList.remove(onTapMarkerPin);
    onTapMarkerPin = Marker(
      point: LatLng(point.latitude, point.longitude),
      child: const Icon(
        size: 40,
        Icons.location_on,
        color: Color.fromARGB(255, 220, 64, 61),
      ),
    );
    onTapMarkerPinList.add(onTapMarkerPin);
  }

  void expandDraggableSheet() {
    dragController.animateTo(
      0.4,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
    );
  }

  void collapseDraggableSheet() {
    dragController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
    );
  }

  Future<LatLng> pointToPlace(Map<String, dynamic> place) async {
    double latitude = place['geometry']['location']['lat'];
    double longitude = place['geometry']['location']['lng'];

    return LatLng(latitude, longitude);
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    var placeId = await getPlaceId(input);

    final String url = '$googlePlaceApi?place_id=$placeId&key=$placeKey';
    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);

    if (json.containsKey('result')) {
      var results = json['result'] as Map<String, dynamic>;
      if (kDebugMode) {
        // print(results);
      }
      return results;
    } else {
      if (kDebugMode) {
        // print('No results found');
      }
      return {};
    }
  }

  Future<String> getPlaceId(String input) async {
    final String url =
        '$googlePlaceIdApi?input=$input&inputtype=textquery&fields=place_id&key=$placeKey';
    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);

    var placeId = '';

    var candidates = json['candidates'] as List<dynamic>;
    if (candidates.isNotEmpty) {
      var placeId = candidates[0]['place_id'] as String;
      // ignore: unnecessary_null_comparison
      if (placeId != null) {
        return placeId;
      } else {
        if (kDebugMode) {
          // print('placeId is null');
        }
      }
    } else {
      if (kDebugMode) {
        // print('No candidates found $candidates');
      }
    }

    return placeId;
  }

  Future<List<dynamic>> placeAutoCompleteSearch(String input) async {
    if (input.isEmpty) {
      return [];
    }
    Uri uri = Uri.https(googleMapsUrl, googlePlaceAutoCompleteApi, {
      "input": input,
      "key": placeKey,
    });

    String? response = await fetchUrl(uri);
    placeList = jsonDecode(response!);
    print(placeList);

    Map<String, dynamic> jsonData = jsonDecode(response);

    descriptionList = [];

    if (jsonData.containsKey("predictions")) {
      List<dynamic> predictions = jsonData["predictions"];
      for (var prediction in predictions) {
        if (prediction.containsKey("description")) {
          String description = prediction["description"];
          descriptionList.add(description);
          if (kDebugMode) {
            print(descriptionList);
          }
        }
      }
      return descriptionList;
    }
    return [];
  }

  Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      if (kDebugMode) {
        // print(e);
      }
    }
    return null;
  }

  Future<void> getMosqueMarker(
      MosqueMarkerProvider mosqueMarkerProvider) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/datasets/senarai_masjid.json');
      var data = jsonDecode(jsonString);

      if (data is List) {
        for (var point in data) {
          Marker marker = Marker(
            key: Key(point['refid'].toString()),
            width: 40.0,
            height: 40.0,
            point: LatLng(point['lat'], point['lng']),
            child: Image.asset('assets/images/mosque_marker.png'),
          );
          markerList.add(marker);
          markerListInfo.add(point);
        }
        print('Cluster markers count: ${markerList.length}');
        markerListFlag = true;
        mosqueMarkerProvider.updateMarkers(markerList);
        mosqueMarkerProvider.updateMarkersInfo(markerListInfo);
        mosqueMarkerProvider.updateMarkersFlag(markerListFlag);
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

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
