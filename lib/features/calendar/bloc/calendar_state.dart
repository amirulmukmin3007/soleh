part of 'calendar_bloc.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<IslamicDate> islamicDate;

  CalendarLoaded({required this.islamicDate});
}

class CalendarError extends CalendarState {
  final String error;

  CalendarError({required this.error});
}
