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
}
