import 'package:flutter/material.dart';

class TimeProvider extends ChangeNotifier {
  // Hijrah Date
  String _hijrahDate = '';
  // Current Date
  String _currentDate = '';
  // Current Time
  String _currentTime = '';
  // Current Meridiem
  String _currentMeridiem = '';

  String get hijrahDate => _hijrahDate;
  String get currentDate => _currentDate;
  String get currentTime => _currentTime;
  String get currentMeridiem => _currentMeridiem;

  void updateHijrahDate(String hijrahDate) {
    _hijrahDate = hijrahDate;
    notifyListeners();
  }

  void updateCurrentDate(String currentDate) {
    _currentDate = currentDate;
    notifyListeners();
  }

  void updateCurrentTime(String currentTime) {
    _currentTime = currentTime;
    notifyListeners();
  }

  void updateCurrentMeridiem(String currentMeridiem) {
    _currentMeridiem = currentMeridiem;
    notifyListeners();
  }
}
