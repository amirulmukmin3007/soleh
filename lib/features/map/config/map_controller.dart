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
      mainDialog(context, 'Location Unavailable',
          Text('Please enable location service'), [
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
}
