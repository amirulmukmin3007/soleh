import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:soleh/provider/asma_ul_husna_provider.dart';
import 'package:soleh/provider/location_provider.dart';
import 'package:soleh/provider/waktu_solat_provider.dart';
import 'package:soleh/shared/api/general.dart';
import 'package:soleh/shared/api/googlemaps.dart';
import 'package:soleh/shared/functions/formatter.dart';

class HomeModel {
  Formatter formatter = Formatter();
  String currentHoliday = '';
  String currentDate = '';
  String currentDay = '';
  String currentHijrahDate = '';

  // Asma Ul Husna
  String auhMeaning = '';
  String auhAR = '';
  String auhEN = '';
  String auhNum = '';

  // String currentDay = '';
  String subuhTime = '';
  String syurukTime = '';
  String zohorTime = '';
  String asarTime = '';
  String maghribTime = '';
  String isyakTime = '';
  // bool waktuSolatFlag = false;

  Future<LocationData> getLiveLocation(
      LocationProvider locationProvider) async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location service is disabled.');
        return LocationData.fromMap({});
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permission denied.');
        return LocationData.fromMap({});
      }
    }

    try {
      LocationData locData = await location.getLocation();

      if (locData.latitude != null && locData.longitude != null) {
        if (locationProvider.currentLatitude == locData.latitude &&
            locationProvider.currentLongitude == locData.longitude) {
          return locData;
        } else {
          locationProvider.updateLocation(locData, locData.latitude!.toDouble(),
              locData.longitude!.toDouble());
          return locData;
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    }
    return LocationData.fromMap({});
  }

  // Get Hijrah Date
  Future<String> getHijrahDate() async {
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

          if (data['data']['hijri']['holidays'].isEmpty) {
            currentHoliday = '';
          } else {
            currentHoliday = data['data']['hijri']['holidays'][0];
          }

          currentDate = formatter.getCurrentDateFormattedAPI();
          currentDay = "$dayAR, $dayEN";
          currentHijrahDate =
              "${data['data']['hijri']['day']} ${data['data']['hijri']['month']['en']} ${data['data']['hijri']['year']}";
          return currentHijrahDate;
        } else {
          print('Invalid JSON structure: Missing hijri data');
        }
      } else {
        print(
            'Failed to fetch Hijrah date. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getHijrahDate: $e');
    }
    return '';
  }

  Future<String> getLocationName(LocationProvider locationProvider,
      double latitude, double longitude) async {
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
              locationProvider
                  .updateLocationName(component['long_name'] as String);
              print(component['long_name']);
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
      WaktuSolatProvider waktuSolatProvider, double lat, double lng) async {
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

            subuhTime =
                formatter.trimSeconds(jakimJson['prayerTime'][0]['fajr']);
            syurukTime =
                formatter.trimSeconds(jakimJson['prayerTime'][0]['syuruk']);
            zohorTime =
                formatter.trimSeconds(jakimJson['prayerTime'][0]['dhuhr']);
            asarTime = formatter.trimSeconds(jakimJson['prayerTime'][0]['asr']);
            maghribTime =
                formatter.trimSeconds(jakimJson['prayerTime'][0]['maghrib']);
            isyakTime =
                formatter.trimSeconds(jakimJson['prayerTime'][0]['isha']);

            waktuSolatProvider.updateWaktuSolatToday(
              true,
              subuhTime,
              syurukTime,
              zohorTime,
              asarTime,
              maghribTime,
              isyakTime,
            );
          } else {
            print(
                'Failed to fetch Jakim data. Status code: ${jakimResponse.statusCode}');
          }
        } else {
          print('Invalid JSON structure: Missing attributes');
        }
      } else {
        print(
            'Failed to fetch prayer times. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getWaktuSolatToday: $e');
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

  Future<void> getAsmaUlHusna(AsmaUlHusnaProvider auhProvider) async {
    try {
      Random random = Random();
      int randomNumber = random.nextInt(99) + 1;

      final response = await http.get(
        Uri.parse('$aladhan$asmaUlHusnaSearch$randomNumber'),
      );
      var data = jsonDecode(response.body);
      auhMeaning = data['data'][0]['en']['meaning'];
      auhAR = data['data'][0]['name'];
      auhEN = data['data'][0]['transliteration'];
      auhNum = data['data'][0]['number'].toString();
      auhProvider.updateAsmaUlHusna(auhMeaning, auhAR, auhEN, auhNum);
      print(data['data'][0]['number']);
    } catch (e) {
      print('Error in getAsmaUlHusna: $e');
    }
  }
}
