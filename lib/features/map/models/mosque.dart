import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MosqueModel {
  String name;
  String place;
  String address;
  String postcode;
  String district;
  String noTel;
  String noFax;
  double lat;
  double lng;
  Marker marker;

  MosqueModel({
    required this.name,
    required this.place,
    required this.address,
    required this.postcode,
    required this.district,
    required this.noTel,
    required this.noFax,
    required this.lat,
    required this.lng,
    required this.marker,
  });

  factory MosqueModel.fromJson(Map<String, dynamic> json) {
    return MosqueModel(
      name: json['name'],
      place: json['place'],
      address: json['address'],
      postcode: json['postcode'],
      district: json['district'],
      noTel: json['no_tel'],
      noFax: json['no_fax'],
      lat: json['lat'],
      lng: json['lng'],
      marker: Marker(
        key: Key(json['refid'].toString()),
        width: 40.0,
        height: 40.0,
        point: LatLng(json['lat'], json['lng']),
        child: Image.asset('assets/images/mosque_marker.png'),
      ),
    );
  }
}

class MosqueListModel {
  List<MosqueModel> mosques = [];

  MosqueListModel({required this.mosques});
}
