import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:soleh/features/home/models/asma_ul_husna.dart';
import 'package:soleh/features/home/models/hijrah_date.dart';
import 'package:soleh/features/home/models/prayer_times.dart';
import 'package:soleh/features/home/models/zikir_harian_model.dart';
import 'package:soleh/features/home/repositories/home_repository.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:geolocator/geolocator.dart' as geo;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  final Formatter formatter = Formatter();
  Timer? _timer;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<HomeInitialEvent>(onInitial);
    on<HomeRefreshDataEvent>(onRefresh);
    on<HomeUpdateTimeEvent>(onUpdateTime);
  }

  Future<void> onInitial(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _loadAllData(emit);
    _startTimer();
  }

  Future<void> onRefresh(
    HomeRefreshDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _loadAllData(emit);
  }

  void onUpdateTime(
    HomeUpdateTimeEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      String currentWaktuSolat = _calculateCurrentWaktuSolat(
        currentState.prayerTimes,
      );

      if (currentWaktuSolat != currentState.currentWaktuSolat) {
        emit(HomeLoaded(
          hijrahDate: currentState.hijrahDate,
          locationName: currentState.locationName,
          prayerTimes: currentState.prayerTimes,
          asmaUlHusna: currentState.asmaUlHusna,
          dayPicture: currentState.dayPicture,
          currentWaktuSolat: currentWaktuSolat,
          zikirHarian: currentState.zikirHarian,
        ));
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => add(HomeUpdateTimeEvent()),
    );
  }

  Future<void> _loadAllData(Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      geo.Position locationData = await repository.getLiveLocation();

      double lat = locationData.latitude;
      double lng = locationData.longitude;

      String locationName = await repository.getLocationName(lat, lng);
      HijrahDateModel hijrahDateModel = await repository.getHijrahDate();
      PrayerTimesModel prayerTimesModel =
          await repository.getPrayerTimes(lat, lng);
      AsmaUlHusnaModel asmaUlHusnaModel = await repository.getAsmaUlHusna();
      ZikirHarianModel zikirHarianModel = await repository.getZikirDaily();
      String dayPicture = repository.getDayPicture();

      String currentWaktuSolat = _calculateCurrentWaktuSolat(prayerTimesModel);

      emit(HomeLoaded(
        hijrahDate: hijrahDateModel,
        locationName: locationName,
        prayerTimes: prayerTimesModel,
        asmaUlHusna: asmaUlHusnaModel,
        dayPicture: dayPicture,
        currentWaktuSolat: currentWaktuSolat,
        zikirHarian: zikirHarianModel,
      ));
    } catch (e, stackTrace) {
      print('Stack trace: $stackTrace');
      emit(HomeError(message: 'Failed to load data: ${e.toString()}'));
    }
  }

  String _calculateCurrentWaktuSolat(PrayerTimesModel prayerTimes) {
    List<String> times = [
      prayerTimes.subuh,
      prayerTimes.syuruk,
      prayerTimes.zohor,
      prayerTimes.asar,
      prayerTimes.maghrib,
      prayerTimes.isyak,
    ];
    List<String> labels = [
      'Subuh',
      'Syuruk',
      'Zohor',
      'Asar',
      'Maghrib',
      'Isyak'
    ];
    return formatter.getCurrentWaktuSolat(times, labels);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
