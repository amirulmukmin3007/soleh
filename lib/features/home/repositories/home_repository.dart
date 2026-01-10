import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:soleh/features/home/models/asma_ul_husna.dart';
import 'package:soleh/features/home/models/hijrah_date.dart';
import 'package:soleh/features/home/models/prayer_times.dart';
import 'package:soleh/features/home/models/zikir_harian_model.dart';
import 'package:soleh/shared/api/general.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:html/parser.dart' as html_parser;

class HomeRepository {
  final Formatter formatter = Formatter();

  Future<geo.Position> getLiveLocation() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        return geo.Position.fromMap({});
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      return geo.Position.fromMap({});
    }

    try {
      geo.Position position = await geo.Geolocator.getCurrentPosition(
        locationSettings:
            geo.AndroidSettings(accuracy: geo.LocationAccuracy.high),
      );

      return position;
    } catch (e) {
      return geo.Position.fromMap({});
    }
  }

  Future<HijrahDateModel> getHijrahDate() async {
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

          final mappedData = {
            'holiday': holiday,
            'currentDate': setDate,
            'currentDay': "$dayAR, $dayEN",
            'currentHijrahDate':
                "${data['data']['hijri']['day']} ${data['data']['hijri']['month']['en']} ${data['data']['hijri']['year']}",
          };

          return HijrahDateModel.fromJson(mappedData);
        }
      }
    } catch (e) {
      print('Error in getHijrahDate: $e');
    }
    return HijrahDateModel.setNull();
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

  Future<PrayerTimesModel> getPrayerTimes(double lat, double lng) async {
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
            final mappedData = {
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
            return PrayerTimesModel.fromJson(mappedData);
          }
        }
      }
    } catch (e) {
      print('Error in getPrayerTimes: $e');
    }
    return PrayerTimesModel.setNull();
  }

  Future<AsmaUlHusnaModel> getAsmaUlHusna() async {
    try {
      Random random = Random();
      int randomNumber = random.nextInt(99) + 1;

      final response = await http.get(
        Uri.parse('$aladhan$asmaUlHusnaSearch$randomNumber'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final mappedData = {
          'meaning': data['data'][0]['en']['meaning'] ?? '',
          'ar': data['data'][0]['name'] ?? '',
          'en': data['data'][0]['transliteration'] ?? '',
          'num': (data['data'][0]['number'] ?? 0).toString(),
        };
        return AsmaUlHusnaModel.fromJson(mappedData);
      }
    } catch (e) {
      print('Error in getAsmaUlHusna: $e');
    }
    return AsmaUlHusnaModel.setNull();
  }

  String getDayPicture() {
    var hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return 'assets/images/morning_time.jpg';
    if (hour >= 12 && hour < 17) return 'assets/images/afternoon_time.jpg';
    if (hour >= 17 && hour < 20) return 'assets/images/evening_time.jpg';
    return 'assets/images/night_time.jpg';
  }

  Future<ZikirHarianModel> getZikirDaily() async {
    try {
      final response = await http.get(
        Uri.parse(zikirHarianUrl),
      );

      if (response.statusCode != 200) {
        print('Failed to load page: ${response.statusCode}');
        return ZikirHarianModel.setNull();
      }

      final document = html_parser.parse(response.body);

      final dayMap = {
        'isnin': 1,
        'selasa': 2,
        'rabu': 3,
        'khamis': 4,
        'jumaat': 5,
        'sabtu': 6,
        'ahad': 7,
      };

      final today = DateTime.now().weekday;

      final headers = document.querySelectorAll('h3[id^="h-zikir-hari-"]');

      for (var header in headers) {
        try {
          final id = header.attributes['id'] ?? '';

          final dayName = id.replaceAll('h-zikir-hari-', '');

          if (!dayMap.containsKey(dayName)) continue;

          if (dayMap[dayName] == today) {
            final title = header.text.trim();

            String? imageUrl;

            final allImages = document.querySelectorAll('img[data-src]');
            for (var img in allImages) {
              final imgTitle = img.attributes['title'] ?? '';
              if (imgTitle.contains('zikir') &&
                  (imgTitle.contains(dayName) ||
                      imgTitle.contains('hari-$dayName'))) {
                imageUrl = img.attributes['data-src'];
                break;
              }
            }

            print('Image URL: $imageUrl');

            final mappedData = {
              'title': title,
              'imageUrl': imageUrl ?? '',
              'day': dayMap[dayName],
              'dayName': dayName,
            };

            return ZikirHarianModel.fromJson(mappedData);
          }
        } catch (e) {
          print('Error parsing item: $e');
        }
      }

      return ZikirHarianModel.setNull();
    } catch (e) {
      print('Error in getZikirDaily: $e');
      return ZikirHarianModel.setNull();
    }
  }

  Map<String, dynamic>? getTodayZikir(List<Map<String, dynamic>> zikirList) {
    final today = DateTime.now().weekday; // 1 = Monday, 7 = Sunday

    try {
      return zikirList.firstWhere(
        (zikir) => zikir['day'] == today,
      );
    } catch (e) {
      print('No zikir found for today');
      return null;
    }
  }
}
