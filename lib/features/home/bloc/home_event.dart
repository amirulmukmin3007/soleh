part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeGetUserCurrentLocation extends HomeEvent {}

class HomeGetCurrentWeather extends HomeEvent {}

class HomeGetCurrentTime extends HomeEvent {}

class HomeGetCurrentDateArabic extends HomeEvent {}

class HomeGetCurrentDayArabic extends HomeEvent {}

class HomeGetRandomAsmaUlHusna extends HomeEvent {}
