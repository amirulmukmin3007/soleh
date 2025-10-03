import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:soleh/shared/api/general.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/functions/formatter.dart';

class HomeRepository {
  final Formatter formatter = Formatter();

  Future<geo.Position> getLiveLocation() async {
    print("🔄 GETTING LOCATION (Geolocator)...");

    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        print("❌ Location permission denied.");
        return geo.Position.fromMap({});
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      print("❌ Location permissions are permanently denied.");
      return geo.Position.fromMap({});
    }

    try {
      geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print("🚨 Failed to get location: $e");
      return geo.Position.fromMap({});
    }
  }

  Future<Map<String, String>> getHijrahDate() async {
    try {
      String setDate = formatter.getCurrentDateFormattedAPI();
      final response = await http.get(
        Uri.parse('$aladhan$dateSearch$setDate'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['hijri'] != null) {
          var dayAR = data['data']['hijri']['weekday']['ar'];
          var dayEN = data['data']['hijri']['weekday']['en'];

          String holiday = '';
          if (data['data']['hijri']['holidays'].isNotEmpty) {
            holiday = data['data']['hijri']['holidays'][0];
          }

          print(
              "${data['data']['hijri']['day']} ${data['data']['hijri']['month']['en']} ${data['data']['hijri']['year']}");

          return {
            'holiday': holiday,
            'currentDate': setDate,
            'currentDay': "$dayAR, $dayEN",
            'currentHijrahDate':
                "${data['data']['hijri']['day']} ${data['data']['hijri']['month']['en']} ${data['data']['hijri']['year']}",
          };
        }
      }
    } catch (e) {
      print('Error in getHijrahDate: $e');
    }
    return {};
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    try {
      final String url =
          'https://$googleMapsUrl/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapKey';

      print(url);
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
              return component['long_name'] as String;
            }
          }
        }
      }
    } catch (e) {
      print('Error in getLocationName: $e');
    }
    return '';
  }

  Future<Map<String, String>> getPrayerTimes(double lat, double lng) async {
    try {
      DateTime now = DateTime.now();
      String date = now.toString().split(' ')[0];
      final String url = '$mpt$lat,$lng';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['data'] != null && json['data']['attributes'] != null) {
          final jakimCode = json['data']['attributes']['jakim_code'];
          final String jakimUrl = '$jakimDuration$jakimCode';
          final jakimResponse = await http.post(Uri.parse(jakimUrl), body: {
            'datestart': date,
            'dateend': date,
          });

          if (jakimResponse.statusCode == 200) {
            final jakimJson = jsonDecode(jakimResponse.body);
            return {
              'subuh':
                  formatter.trimSeconds(jakimJson['prayerTime'][0]['fajr']),
              'syuruk':
                  formatter.trimSeconds(jakimJson['prayerTime'][0]['syuruk']),
              'zohor':
                  formatter.trimSeconds(jakimJson['prayerTime'][0]['dhuhr']),
              'asar': formatter.trimSeconds(jakimJson['prayerTime'][0]['asr']),
              'maghrib':
                  formatter.trimSeconds(jakimJson['prayerTime'][0]['maghrib']),
              'isyak':
                  formatter.trimSeconds(jakimJson['prayerTime'][0]['isha']),
            };
          }
        }
      }
    } catch (e) {
      print('Error in getPrayerTimes: $e');
    }
    return {};
  }

  Future<Map<String, String>> getAsmaUlHusna() async {
    try {
      Random random = Random();
      int randomNumber = random.nextInt(99) + 1;

      final response = await http.get(
        Uri.parse('$aladhan$asmaUlHusnaSearch$randomNumber'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          'meaning': data['data'][0]['en']['meaning'] ?? '',
          'ar': data['data'][0]['name'] ?? '',
          'en': data['data'][0]['transliteration'] ?? '',
          'num': (data['data'][0]['number'] ?? 0).toString(),
        };
      }
    } catch (e) {
      print('Error in getAsmaUlHusna: $e');
    }
    return {};
  }

  String getDayPicture() {
    var hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return 'assets/images/morning_time.jpg';
    if (hour >= 12 && hour < 17) return 'assets/images/afternoon_time.jpg';
    if (hour >= 17 && hour < 20) return 'assets/images/evening_time.jpg';
    return 'assets/images/night_time.jpg';
  }
}
