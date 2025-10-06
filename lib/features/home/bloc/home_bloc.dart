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

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<HomeInitialEvent>(loadAllData);
    on<HomeRefreshDataEvent>(loadAllData);
  }

  Future<void> loadAllData(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    print('🟦 Starting loadAllData');
    emit(HomeLoading());

    try {
      // Get location
      geo.Position locationData = await repository.getLiveLocation();

      double lat = locationData.latitude;
      double lng = locationData.longitude;

      // Get all data from repository
      String locationName = await repository.getLocationName(lat, lng);
      Map<String, String> hijrahData = await repository.getHijrahDate();
      Map<String, String> prayerTimesData =
          await repository.getPrayerTimes(lat, lng);
      Map<String, String> asmaUlHusnaData = await repository.getAsmaUlHusna();
      Map<String, dynamic> zikirData = await repository.getZikirDaily();
      String dayPicture = repository.getDayPicture();

      // Create models
      final prayerTimesModel = PrayerTimesModel(
        subuh: prayerTimesData['subuh'] ?? '',
        syuruk: prayerTimesData['syuruk'] ?? '',
        zohor: prayerTimesData['zohor'] ?? '',
        asar: prayerTimesData['asar'] ?? '',
        maghrib: prayerTimesData['maghrib'] ?? '',
        isyak: prayerTimesData['isyak'] ?? '',
      );

      final asmaUlHusnaModel = AsmaUlHusnaModel(
        auhMeaning: asmaUlHusnaData['meaning'] ?? '',
        auhAR: asmaUlHusnaData['ar'] ?? '',
        auhEN: asmaUlHusnaData['en'] ?? '',
        auhNum: asmaUlHusnaData['num'] ?? '',
      );

      final hijrahDateModel = HijrahDateModel(
        holiday: hijrahData['holiday'] ?? '',
        currentDate: hijrahData['currentDate'] ?? '',
        currentDay: hijrahData['currentDay'] ?? '',
        currentHijrahDate: hijrahData['currentHijrahDate'] ?? '',
      );

      final zikirHarianModel = ZikirHarianModel(
        title: zikirData['title'] ?? '',
        imageUrl: zikirData['imageUrl'] ?? '',
        day: zikirData['day'] ?? '',
        dayName: zikirData['dayName'] ?? '',
      );

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
    // Business logic here
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
}
