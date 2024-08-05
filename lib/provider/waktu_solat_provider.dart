import 'package:flutter/material.dart';

class WaktuSolatProvider extends ChangeNotifier {
  bool _waktuSolatFlag = false;
  String _subuh = '';
  String _syuruk = '';
  String _zohor = '';
  String _asar = '';
  String _maghrib = '';
  String _isyak = '';

  List<String> waktuSolatLabel = [
    'Subuh',
    'Syuruk',
    'Zohor',
    'Asar',
    'Maghrib',
    'Isyak'
  ];

  List<String> waktuSolatTime = [];

  bool get waktuSolatFlag => _waktuSolatFlag;
  String get subuh => _subuh;
  String get syuruk => _syuruk;
  String get zohor => _zohor;
  String get asar => _asar;
  String get maghrib => _maghrib;
  String get isyak => _isyak;

  void updateWaktuSolatToday(bool waktuSolatFlag, String subuh, String syuruk,
      String zohor, String asar, String maghrib, String isyak) {
    _waktuSolatFlag = waktuSolatFlag;
    _subuh = subuh;
    _syuruk = syuruk;
    _zohor = zohor;
    _asar = asar;
    _maghrib = maghrib;
    _isyak = isyak;
    waktuSolatTime = [_subuh, _syuruk, _zohor, _asar, _maghrib, _isyak];
    notifyListeners();
  }
}
