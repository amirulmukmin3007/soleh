part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class LoadDataByYearEvent extends CalendarEvent {
  final int year;
  final Map<DateTime, List<String>> events;

  LoadDataByYearEvent({required this.year, required this.events});
}
