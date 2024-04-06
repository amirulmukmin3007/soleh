import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:soleh/shared/api/general.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/functions/formatter.dart';

class HomeModel {
  Formatter formatter = Formatter();
  String currentHijrahDate = '';
  String currentLocation = '';
  String setDate = '';
  String currentDate = '';
  String currentHoliday = '';
  String currentTime = '';
  String currentMeridiem = '';
  double currentLat = 0.0;
  double currentLng = 0.0;
  bool currentDateFlag = false;

  // Asma Ul Husna
  Map<String, dynamic> asmaUlHusna = {};
  String auhMeaning = '';
  String auhAR = '';
  String auhEN = '';
  String auhNum = '';
  bool auhFlag = false;

  // Waktu Solat
  String currentDay = '';
  String subuhTime = '';
  String syurukTime = '';
  String zohorTime = '';
  String asarTime = '';
  String maghribTime = '';
  String isyakTime = '';
  List<String> waktuSolatToday = [];
  String currentWaktuSolat = '';
  List<String> waktuSolatList = [
    'Subuh',
    'Syuruk',
    'Zohor',
    'Asar',
    'Maghrib',
    'Isyak'
  ];
  bool waktuSolatFlag = false;

  // Get Hijrah Date
  Future<String> getHijrahDate() async {
    try {
      String setDate = formatter.getCurrentDateFormattedAPI();
      final response = await http.get(
        Uri.parse('$aladhan$dateSearch$setDate'),
      );
      var data = jsonDecode(response.body);
      // print(data['data']['hijri']['holidays'][0]);
      var dayAR = data['data']['hijri']['weekday']['ar'];
      var dayEN = data['data']['hijri']['weekday']['en'];

      if (data['data']['hijri']['holidays'].isEmpty) {
        currentHoliday = '';
      } else {
        currentHoliday = data['data']['hijri']['holidays'][0];
      }

      currentDate = formatter.getCurrentDateFormattedAPI();
      currentDay = "$dayAR, $dayEN";
      currentHijrahDate =
          "${data['data']['hijri']['day']} ${data['data']['hijri']['month']['en']} ${data['data']['hijri']['year']}";
      currentDateFlag = true;
      return currentHijrahDate;
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    try {
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
              currentLocation = component['long_name'] as String;
              return component['long_name'] as String;
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<Map<String, dynamic>> getWaktuSolatToday(
      double lat, double lng) async {
    try {
      DateTime now = DateTime.now();
      String date = now.toString().split(' ')[0];
      final String url = '$mpt$lat,$lng';
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      final jakimCode = json['data']['attributes']['jakim_code'];

      final String jakimUrl = '$jakimDuration$jakimCode';

      final jakimResponse = await http.post(Uri.parse(jakimUrl), body: {
        'datestart': date,
        'dateend': date,
      });

      final jakimJson = jsonDecode(jakimResponse.body);

      subuhTime = formatter.trimSeconds(jakimJson['prayerTime'][0]['fajr']);
      syurukTime = formatter.trimSeconds(jakimJson['prayerTime'][0]['syuruk']);
      zohorTime = formatter.trimSeconds(jakimJson['prayerTime'][0]['dhuhr']);
      asarTime = formatter.trimSeconds(jakimJson['prayerTime'][0]['asr']);
      maghribTime =
          formatter.trimSeconds(jakimJson['prayerTime'][0]['maghrib']);
      isyakTime = formatter.trimSeconds(jakimJson['prayerTime'][0]['isha']);
      waktuSolatFlag = true;
    } catch (e) {
      print(e);
    }

    return {};
  }

  String getDayPicture() {
    var hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      return 'assets/images/morning_time.jpg';
    } else if (hour >= 12 && hour < 17) {
      return 'assets/images/afternoon_time.jpg';
    } else if (hour >= 17 && hour < 20) {
      return 'assets/images/evening_time.jpg';
    } else if (hour >= 20 && hour < 24) {
      return 'assets/images/night_time.jpg';
    } else if (hour >= 0 && hour < 6) {
      return 'assets/images/night_time.jpg';
    } else {
      return 'assets/images/morning_time.jpg';
    }
  }

  Future<void> getAsmaUlHusna() async {
    try {
      Random random = Random();
      int randomNumber = random.nextInt(99) + 1;

      final response = await http.get(
        Uri.parse('$aladhan$asmaUlHusnaSearch$setDate$randomNumber'),
      );
      var data = jsonDecode(response.body);
      auhMeaning = data['data'][0]['en']['meaning'];
      auhAR = data['data'][0]['name'];
      auhEN = data['data'][0]['transliteration'];
      auhNum = data['data'][0]['number'].toString();
      print(data['data'][0]['number']);
    } catch (e) {}
  }
}
