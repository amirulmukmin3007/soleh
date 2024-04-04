import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soleh/shared/api/general.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/functions/formatter.dart';

class HomeModel {
  Formatter formatter = Formatter();
  String currentHijrahDate = '';
  String currentLocation = '';
  String currentDate = '';
  String currentTime = '';
  String currentMeridiem = '';
  double currentLat = 0.0;
  double currentLng = 0.0;

  // Waktu Solat
  String subuhTime = '';
  String zohorTime = '';
  String asarTime = '';
  String maghribTime = '';
  String isyakTime = '';

  // Get Hijrah Date
  Future<String> getHijrahDate() async {
    try {
      String currentDate = formatter.getCurrentDateFormattedAPI();
      final response = await http.get(
        Uri.parse('$aladhan$currentDate'),
      );
      var data = jsonDecode(response.body);
      currentHijrahDate =
          "${data['data']['hijri']['day']} ${data['data']['hijri']['month']['en']} ${data['data']['hijri']['year']}";
      return data;
    } catch (e) {}
    return '';
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    final String url =
        'https://$googleMapsUrl/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapKey';
    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);

    if (json['status'] == 'OK') {
      var results = json['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        var addressComponents =
            results[0]['address_components'] as List<dynamic>;
        for (var component in addressComponents) {
          var types = component['types'] as List<dynamic>;
          if (types.contains('locality')) {
            print(component['long_name']);
            currentLocation = component['long_name'] as String;
            return component['long_name'] as String;
          }
        }
      }
    }

    // Return an empty string if location name couldn't be retrieved
    return '';
  }

  Future<Map<String, dynamic>> getWaktuSolatToday(
      double lat, double lng) async {
    DateTime now = DateTime.now();
    print("latlng 1 : " + lat.toString() + ", " + lng.toString());
    var lat2 = lat.toString();
    var lng2 = lng.toString();
    print("latlng 2 : $lat2, $lng2");
    String date = now.toString().split(' ')[0];
    final String url = '$mpt$lat2,$lng2';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    final jakimCode = json['data']['attributes']['jakim_code'];

    final String jakimUrl = '$jakimDuration$jakimCode';

    final jakimResponse = await http.post(Uri.parse(jakimUrl), body: {
      'datestart': date,
      'dateend': date,
    });

    final jakimJson = jsonDecode(jakimResponse.body);

    subuhTime = jakimJson['prayerTime'][0]['fajr'];
    zohorTime = jakimJson['prayerTime'][0]['dhuhr'];
    asarTime = jakimJson['prayerTime'][0]['asr'];
    maghribTime = jakimJson['prayerTime'][0]['maghrib'];
    isyakTime = jakimJson['prayerTime'][0]['isha'];

    return {};
  }
}
