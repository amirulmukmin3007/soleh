part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeRefreshDataEvent extends HomeEvent {}

class HomeUpdateTimeEvent extends HomeEvent {}
