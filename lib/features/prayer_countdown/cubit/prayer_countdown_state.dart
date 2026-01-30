part of 'prayer_countdown_cubit.dart';

// State
class PrayerCountdownState extends Equatable {
  final String timeRemaining;
  final String nextPrayer;
  final bool isCountingDown;

  const PrayerCountdownState({
    this.timeRemaining = '00:00:00',
    this.nextPrayer = '',
    this.isCountingDown = false,
  });

  PrayerCountdownState copyWith({
    String? timeRemaining,
    String? nextPrayer,
    bool? isCountingDown,
  }) {
    return PrayerCountdownState(
      timeRemaining: timeRemaining ?? this.timeRemaining,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      isCountingDown: isCountingDown ?? this.isCountingDown,
    );
  }

  @override
  List<Object?> get props => [timeRemaining, nextPrayer, isCountingDown];
}
