part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeWaitingForPermission extends HomeState {}

class HomeLoaded extends HomeState {
  final HijrahDateModel hijrahDate;
  final String locationName;
  final PrayerTimesModel prayerTimes;
  final AsmaUlHusnaModel asmaUlHusna;
  final String dayPicture;
  final String currentWaktuSolat;
  final ZikirHarianModel zikirHarian;

  HomeLoaded({
    required this.hijrahDate,
    required this.locationName,
    required this.prayerTimes,
    required this.asmaUlHusna,
    required this.dayPicture,
    required this.currentWaktuSolat,
    required this.zikirHarian,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
