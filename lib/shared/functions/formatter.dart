import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatter {
  List<String> splitAddressAtFirstComma(String address) {
    List<String> parts = address.split(',');

    if (parts.length > 1) {
      String firstPart = parts[0];

      String secondPart = parts.sublist(1).join(',').trim();

      return [firstPart.trim(), secondPart];
    } else {
      return [address.trim(), ''];
    }
  }

  String formatNumericValue(String value) {
    int convertValue = int.parse(value);
    if (convertValue >= 10000) {
      double formattedValue = convertValue / 1000.0;
      return '${formattedValue.toStringAsFixed(1)}K';
    } else {
      return convertValue.toString();
    }
  }

  String getCurrentDateFormattedAPI() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return formattedDate;
  }

  String getTime() {
    DateTime now = DateTime.now();
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String getMeridiem() {
    DateTime now = DateTime.now();
    String period = (now.hour < 12) ? 'am' : 'pm';
    return period;
  }

  String getCurrentWaktuSolat(
      List<String> waktuSolatToday, List<String> waktuSolatList) {
    TimeOfDay currentTime = TimeOfDay.now();

    if (kDebugMode) print('$waktuSolatToday $waktuSolatList');

    List<TimeOfDay> times = waktuSolatToday.map((waktuSolat) {
      List<String> parts = waktuSolat.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }).toList();

    for (int i = 0; i < times.length; i++) {
      TimeOfDay start = times[i];
      TimeOfDay end = (i + 1 < times.length)
          ? times[i + 1]
          : times[0]; // Wrap around to the first time

      // Check if the current time is between the start and end times
      if (currentTime.hour > start.hour ||
          (currentTime.hour == start.hour &&
              currentTime.minute >= start.minute)) {
        if (currentTime.hour < end.hour ||
            (currentTime.hour == end.hour && currentTime.minute < end.minute)) {
          return waktuSolatList[i];
        }
      }
    }

    // If no match is found, wrap around to the last prayer time
    return waktuSolatList[waktuSolatList.length - 1];
  }

  String trimSeconds(String timeString) {
    List<String> parts = timeString.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return timeString;
  }
}
