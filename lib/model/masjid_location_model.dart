import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'dart:isolate';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:soleh/shared/api/general.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:soleh/themes/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapModel {
  final unfocusNode = FocusNode();

  // Search bar
  TextEditingController? textController;
  LocationData? currentLocation;
  LatLng? currentLatLng;

  // Searching
  Map<String, dynamic> placeList = {};
  List<dynamic> descriptionList = [];

  // POI
  List<dynamic> masjidList = [];

  // Map Controller
  MapController mapController = MapController();
  final dragController = DraggableScrollableController();

  // Clustering
  late List<Marker> parentClusterMarkers;
  List<Map<String, dynamic>> parentClusterMarkersInfo = [];

  // Radius
  List<CircleMarker> radiusCircleList = [];
  List<String> radiusType = ['M', 'KM'];
  String selectedRadiusType = 'M';
  TextEditingController radiusController = TextEditingController();
  List<Map<String, dynamic>> markerWithinRadius = [];

  // Flags
  bool clusterFlag = false;
  bool masjidFlag = false;
  bool radiusFlag = false;
  bool markerWithinRadiusFlag = false;
  bool onTapMarkerFlag = false;

  // Call Formatter function
  Formatter formatter = Formatter();

  // Draggable Sheet
  late String dragLocationNameLarge = '';
  late String dragLocationNameSmall = '';
  late String dragDistrict = '';
  late String dragNoTel = '';
  late String dragLat = '';
  late String dragLong = '';
  late String dragDistance = '';

  // On Tap State Management
  late Marker onTapMarkerPin =
      Marker(point: LatLng(myLat, myLong), child: Container());
  late double onTapLat;
  late double onTapLong;
  late List<Marker> onTapMarkerPinList = [];

  // Malaysia Lat Long
  double myLat = 5.879046502689209;
  double myLong = 108.87773057359271;

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
      0.2,
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

  Future<List<dynamic>> searchPlaces(String input) async {
    String query = '$normatimSearch$input&format=json';
    final response = await http.get(Uri.parse(query));

    final json = jsonDecode(response.body) as List<dynamic>;

    return json;
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
        print(results);
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
    Uri uri = Uri.https(googleMapsUrl, googlePlaceAutoCompleteApi, {
      "input": input,
      "key": placeKey,
    });

    String? response = await fetchUrl(uri);
    placeList = jsonDecode(response!);

    Map<String, dynamic> jsonData = jsonDecode(response);

    descriptionList = [];

    if (jsonData.containsKey("predictions")) {
      List<dynamic> predictions = jsonData["predictions"];
      for (var prediction in predictions) {
        if (prediction.containsKey("description")) {
          String description = prediction["description"];
          descriptionList.add(description);
          if (kDebugMode) {
            // print(descriptionList);
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

  void moveCameraToLocation(LatLng location) {
    mapController.move(location, 15.0);
  }

  void moveCameraToMasjid(LatLng location) {
    mapController.move(location, 20);
  }

  // void getDatapoints(SendPort sendPort) async {
  //   // int count = 0;
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //         // 'https://devmap.zen.com.my/wp-json/mobile_app/googlemaps/datapoints',
  //         'https://pakejexternal.mooo.com/api/rangkaian',
  //       ),
  //     );
  //     var data = jsonDecode(response.body);
  //     if (data is List) {
  //       for (var point in data) {
  //         String markerImage = setMarkerType(point['service_type']);
  //         // print(count++);
  //         Marker marker = Marker(
  //           key: Key(point['refid'].toString()),
  //           width: 40.0,
  //           height: 40.0,
  //           point:
  //               LatLng(double.parse(point['lat']), double.parse(point['lng'])),
  //           child: Image.asset(markerImage),
  //         );
  //         parentClusterMarkersInfo.add(point);
  //         parentClusterMarkers.add(marker);
  //       }
  //       print('Cluster markers count: ${parentClusterMarkersInfo.length}');
  //       clusterFlag = true;
  //       ClusterMarkersDataPacket packet = ClusterMarkersDataPacket(
  //           parentClusterMarkers, parentClusterMarkersInfo, clusterFlag);
  //       sendPort.send(packet);
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print('error');
  //   }
  // }

  // Future<void> getDatapoints(SendPort sendPort) async {
  //   try {
  //     String jsonString =
  //         await rootBundle.loadString('assets/datasets/senarai_masjid.json');
  //     var data = jsonDecode(jsonString);
  //     data = data['Sheet1'];

  //     print(data);

  //     if (data is List) {
  //       for (var point in data) {
  //         print('Nice');
  //         // String markerImage = setMarkerType(point['service_type']);
  //         Marker marker = Marker(
  //           key: Key(point['refid'].toString()),
  //           width: 40.0,
  //           height: 40.0,
  //           point: LatLng(point['lat'], point['lng']),
  //           child: Icon(FluentIcons.location_16_regular),
  //         );
  //         parentClusterMarkersInfo.add(point);
  //         parentClusterMarkers.add(marker);
  //       }
  //       print('Cluster markers count: ${parentClusterMarkersInfo.length}');
  //       clusterFlag = true;
  //       ClusterMarkersDataPacket packet = ClusterMarkersDataPacket(
  //           parentClusterMarkers, parentClusterMarkersInfo, clusterFlag);
  //       sendPort.send(packet);
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print('Error: $e');
  //   }
  // }

  Future<ClusterMarkersDataPacket> getDatapoints() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/datasets/senarai_masjid.json');
      var data = jsonDecode(jsonString);
      data = data['Sheet1'];

      print(data);

      if (data is List) {
        for (var point in data) {
          print('Nice');
          // String markerImage = setMarkerType(point['service_type']);
          Marker marker = Marker(
            key: Key(point['refid'].toString()),
            width: 40.0,
            height: 40.0,
            point: LatLng(point['lat'], point['lng']),
            child: Image.asset('assets/images/mosque_marker.png'),
          );
          parentClusterMarkersInfo.add(point);
          parentClusterMarkers.add(marker);
        }
        print('Cluster markers count: ${parentClusterMarkersInfo.length}');
        clusterFlag = true;
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }

    return ClusterMarkersDataPacket(
      markers: parentClusterMarkers,
      markersInfo: parentClusterMarkersInfo,
      clusterFlag: clusterFlag,
    );
  }

  String setMarkerType(String type) {
    String valueToCompare = type;

    switch (valueToCompare) {
      case "Drop-Off only":
        return 'assets/images/public/markers/drop-off-marker.png';
      case "N/A":
        return 'assets/images/public/markers/drop-off-marker.png';
      case "PICKUP & DROP OFF":
        return 'assets/images/public/markers/pick-up-drop-off-marker.png';
      case "PICK UP ONLY":
        return 'assets/images/public/markers/pick-up-marker.png';
      case "Pick-Up & Drop-Off":
        return 'assets/images/public/markers/pick-up-drop-off-marker.png';
      case "Pick-Up only":
        return 'assets/images/public/markers/pick-up-marker.png';
      default:
    }
    return '';
  }

  Map<String, dynamic> getRangkaianInfo(String refid) {
    Map<String, dynamic>? result = parentClusterMarkersInfo.firstWhere(
      (point) => point['refid'] == refid,
    );
    return result;
  }

  Future<List<dynamic>> getMasjid(String searchQuery) async {
    if (searchQuery != '') {
      List<dynamic> filteredMasjid = parentClusterMarkersInfo.where((point) {
        String address = point['address'].toString().toLowerCase();
        return address.contains(searchQuery.toLowerCase());
      }).toList();

      masjidList.clear();
      masjidList.addAll(filteredMasjid);
      return masjidList;
    } else if (searchQuery == '') {
      masjidList.clear();
      return masjidList;
    }
    return masjidList;
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

  void malaysiaBirdView() {
    mapController.move(LatLng(myLat, myLong), 5.0);
  }

  void openNavigationURL(String app, String latFrom, String longFrom,
      String latTo, String longTo) async {
    if (app == 'waze') {
      String url = wazeNavigate +
          wazeToLL +
          latTo +
          wazeToMiddle +
          longTo +
          wazeFromLL +
          latFrom +
          wazeToMiddle +
          longFrom;
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else if (app == 'googlemaps') {
      String url = "$googlemapsNavigate$latFrom,$longFrom/$latTo,$longTo";
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  List<CircleMarker> setRadius(currentLat, currentLng, radius) {
    radiusCircleList = [];
    CircleMarker radiusCircle = CircleMarker(
      radius: double.parse(radius),
      point: LatLng(currentLat, currentLng),
      useRadiusInMeter: true,
      color: ColorTheme.primary.withOpacity(0.2),
      borderColor: ColorTheme.primary,
      borderStrokeWidth: 2.0,
    );
    radiusCircleList.add(radiusCircle);

    return radiusCircleList;
  }

  void initState(BuildContext context) {}
  void dispose() {
    unfocusNode.dispose();
    textController?.dispose();
  }
}

class ClusterMarkersDataPacket {
  final List<Marker> markers;
  final List<Map<String, dynamic>> markersInfo;
  final bool clusterFlag;

  ClusterMarkersDataPacket(
      {required this.markers,
      required this.markersInfo,
      required this.clusterFlag});
}
