import 'package:flutter/material.dart';

class AsmaUlHusnaProvider extends ChangeNotifier {
  String _meaning = '';
  String _inArabic = '';
  String _inEnglish = '';
  String _number = '';

  String get meaning => _meaning;
  String get inArabic => _inArabic;
  String get inEnglish => _inEnglish;
  String get number => _number;

  void updateAsmaUlHusna(
      String meaning, String inArabic, String inEnglish, String number) {
    _meaning = meaning;
    _inArabic = inArabic;
    _inEnglish = inEnglish;
    _number = number;
    notifyListeners();
  }
}
