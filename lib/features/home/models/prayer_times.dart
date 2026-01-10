class PrayerTimesModel {
  final String subuh;
  final String syuruk;
  final String zohor;
  final String asar;
  final String maghrib;
  final String isyak;

  PrayerTimesModel({
    required this.subuh,
    required this.syuruk,
    required this.zohor,
    required this.asar,
    required this.maghrib,
    required this.isyak,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(
      subuh: json['subuh'],
      syuruk: json['syuruk'],
      zohor: json['zohor'],
      asar: json['asar'],
      maghrib: json['maghrib'],
      isyak: json['isyak'],
    );
  }

  factory PrayerTimesModel.setNull() {
    return PrayerTimesModel(
      subuh: '',
      syuruk: '',
      zohor: '',
      asar: '',
      maghrib: '',
      isyak: '',
    );
  }
}
