import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'prayer_countdown_state.dart';

class PrayerCountdownCubit extends Cubit<PrayerCountdownState> {
  Timer? _timer;

  PrayerCountdownCubit() : super(const PrayerCountdownState());

  void startCountdown({
    required String currentPrayer,
    required Map<String, String> prayerTimes,
  }) {
    _timer?.cancel();

    final nextPrayerInfo = _getNextPrayer(currentPrayer, prayerTimes);

    emit(state.copyWith(
      nextPrayer: nextPrayerInfo['name'],
      isCountingDown: true,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = _calculateTimeRemaining(nextPrayerInfo['time']!);

      if (remaining == '00:00:00') {
        final newNextPrayer =
            _getNextPrayer(nextPrayerInfo['name']!, prayerTimes);
        emit(state.copyWith(
          timeRemaining: '00:00:00',
          nextPrayer: newNextPrayer['name'],
        ));

        startCountdown(
            currentPrayer: nextPrayerInfo['name']!, prayerTimes: prayerTimes);
      } else {
        emit(state.copyWith(timeRemaining: remaining));
      }
    });
  }

  Map<String, String> _getNextPrayer(
      String currentPrayer, Map<String, String> prayerTimes) {
    final prayers = ['Subuh', 'Syuruk', 'Zohor', 'Asar', 'Maghrib', 'Isyak'];
    final times = [
      prayerTimes['subuh']!,
      prayerTimes['syuruk']!,
      prayerTimes['zohor']!,
      prayerTimes['asar']!,
      prayerTimes['maghrib']!,
      prayerTimes['isyak']!,
    ];

    final now = DateTime.now();

    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = _parseTime(times[i]);

      if (prayerTime.isAfter(now)) {
        return {
          'name': prayers[i],
          'time': times[i],
        };
      }
    }

    return {
      'name': prayers[0],
      'time': times[0],
    };
  }

  DateTime _parseTime(String timeString) {
    final now = DateTime.now();

    String cleanTime = timeString.replaceAll(RegExp(r'[AP]M'), '').trim();

    final parts = cleanTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    if (timeString.contains('PM') && hour != 12) {
      hour += 12;
    } else if (timeString.contains('AM') && hour == 12) {
      hour = 0;
    }

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _calculateTimeRemaining(String targetTimeString) {
    final now = DateTime.now();
    var targetTime = _parseTime(targetTimeString);

    // If target time is before now, it's tomorrow
    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(const Duration(days: 1));
    }

    final difference = targetTime.difference(now);

    if (difference.isNegative) {
      return '00:00:00';
    }

    final hours = difference.inHours.toString().padLeft(2, '0');
    final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  void stopCountdown() {
    _timer?.cancel();
    emit(state.copyWith(isCountingDown: false));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
