import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/shared/component/dialogs.dart';

class MapConfig {
  double myLat = 5.879046502689209;
  double myLong = 108.87773057359271;
  void goToMyLocation(BuildContext context, MapController mapController,
      double? myLat, double? myLong) {
    if (myLat == null || myLong == null) {
      CustomDialog(
          title: 'Location Unavailable',
          content: Text('Please enable location service'),
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

  void malaysiaBirdView(MapController mapController) {
    mapController.move(LatLng(myLat, myLong), 5.2);
  }

  void goToPlace(BuildContext context, MapController mapController,
      String place, double lat, double long) {
    mapController.move(LatLng(lat, long), 15.0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(place),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
