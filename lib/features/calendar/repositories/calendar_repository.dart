import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:soleh/features/calendar/models/islamic_date.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarRepository {
  Future<List<IslamicDate>> getIslamicDates(
      Map<DateTime, List<String>> events, int year) async {
    try {
      final supabase = Supabase.instance.client;

      final data = await supabase
          .from('islamic_dates')
          .select()
          .gte('english_date', '$year-01-01')
          .lte('english_date', '$year-12-31');

      for (var element in data) {
        try {
          final date = DateFormat('yyyy-MM-dd').parse(element['english_date']);
          final normalizedDate = DateTime.utc(date.year, date.month, date.day);
          final occasion = "${element['occasion']} - ${element['hijrah_date']}";

          if (events.containsKey(normalizedDate)) {
            events[normalizedDate]!.add(occasion);
          } else {
            events[normalizedDate] = [occasion];
          }
        } catch (dateError) {
          log('Error parsing date for element: $element — $dateError');
          continue;
        }
      }

      return data.map((e) => IslamicDate.fromMap(e)).toList(); // ✅
    } catch (e) {
      log('Error fetching Islamic dates: $e');
      return [];
    }
  }
}
