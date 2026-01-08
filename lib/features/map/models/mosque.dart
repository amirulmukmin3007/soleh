import 'package:flutter_map/flutter_map.dart';

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
}

class MosqueListModel {
  List<MosqueModel> mosques = [];

  MosqueListModel({required this.mosques});
}
