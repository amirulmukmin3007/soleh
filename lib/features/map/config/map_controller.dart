import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:soleh/shared/component/dialogs.dart';

class MapConfig {
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
}
