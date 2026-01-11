import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MosqueModel {
  String refid;
  String name;
  String place;
  String address;
  String postcode;
  String state;
  String district;
  String noTel;
  String noFax;
  double lat;
  double lng;
  Marker marker;

  MosqueModel({
    required this.refid,
    required this.name,
    required this.place,
    required this.address,
    required this.postcode,
    required this.state,
    required this.district,
    required this.noTel,
    required this.noFax,
    required this.lat,
    required this.lng,
    required this.marker,
  });

  factory MosqueModel.fromJson(Map<String, dynamic> json) {
    return MosqueModel(
      refid: json['refid'].toString(),
      name: json['name'] ?? '',
      place: json['place'] ?? '',
      address: json['address'] ?? '',
      postcode: json['postcode'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      noTel: json['no_tel'] ?? '',
      noFax: json['no_fax'] ?? '',
      lat: json['lat'] ?? 0.0,
      lng: json['lng'] ?? 0.0,
      marker: Marker(
        key: Key(json['refid'].toString()),
        width: 40.0,
        height: 40.0,
        point: LatLng(json['lat'], json['lng']),
        child: Image.asset('assets/images/mosque_marker.png'),
      ),
    );
  }

  factory MosqueModel.setNull() {
    return MosqueModel(
      refid: '',
      name: '',
      place: '',
      address: '',
      postcode: '',
      state: '',
      district: '',
      noTel: '',
      noFax: '',
      lat: 0.0,
      lng: 0.0,
      marker: Marker(
        key: Key(''),
        width: 40.0,
        height: 40.0,
        point: LatLng(0.0, 0.0),
        child: Image.asset('assets/images/mosque_marker.png'),
      ),
    );
  }
}

class MosqueListModel {
  List<MosqueModel> mosques = [];
  List<Marker> get markers => mosques.map((m) => m.marker).toList();

  MosqueListModel({required this.mosques});
}
