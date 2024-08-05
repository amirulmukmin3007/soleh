import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/model/home_model.dart';
import 'package:soleh/model/map_model.dart';
import 'package:soleh/provider/asma_ul_husna_provider.dart';
import 'package:soleh/provider/location_provider.dart';
import 'package:soleh/provider/time_provider.dart';
import 'package:soleh/provider/waktu_solat_provider.dart';
import 'package:soleh/shared/component/asmaulhusna_card.dart';
import 'package:soleh/shared/component/home_header.dart';
import 'package:soleh/shared/component/scaffoldbackground.dart';
import 'package:soleh/shared/component/shimmer.dart';
import 'package:soleh/shared/component/waktusolat_card.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:location/location.dart';
import 'package:soleh/themes/colors.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";
  const Home({super.key, required this.isActive});
  final bool isActive;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeModel homeModel;
  late TimeProvider timeProvider;
  late LocationProvider locationProvider;
  late WaktuSolatProvider waktuSolatProvider;
  late AsmaUlHusnaProvider asmaUlHusnaProvider;
  late MapModel mapModel;
  Formatter formatter = Formatter();
  String currentWaktuSolat = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    homeModel = HomeModel();
    timeProvider = TimeProvider();
    locationProvider = LocationProvider();
    waktuSolatProvider = WaktuSolatProvider();
    asmaUlHusnaProvider = AsmaUlHusnaProvider();
    mapModel = MapModel();
    homeModel
        .getHijrahDate()
        .then((value) => timeProvider.updateHijrahDate(value));
    initialize();
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            callGetTime();
          },
        );
      },
    );
    Timer.periodic(const Duration(minutes: 1), (timer) {
      callGetLiveLocation();
      callGetLocationName();
      callGetCurrentWaktuSolat();
    });
  }

  void initialize() async {
    await callGetTime();
    await callGetWaktuSolatToday();
    await callGetLiveLocation();
    await callGetLocationName();
    callGetCurrentWaktuSolat();
    await callGetAsmaUlHusna();
  }

  Future<void> callGetTime() async {
    timeProvider.updateCurrentTime(formatter.getTime());
    timeProvider.updateCurrentMeridiem(formatter.getMeridiem());
    setState(() {});
  }

  Future<void> callGetHijrahDate() async {
    homeModel
        .getHijrahDate()
        .then((value) => timeProvider.updateHijrahDate(value));
    setState(() {});
  }

  Future<void> callGetLiveLocation() async {
    await homeModel.getLiveLocation(locationProvider);
    setState(() {});
  }

  Future<void> callGetLocationName() async {
    double lat = locationProvider.currentLatitude ?? mapModel.defaultLat;
    double lng = locationProvider.currentLongitude ?? mapModel.defaultLng;
    await homeModel.getLocationName(locationProvider, lat, lng);
    setState(() {});
  }

  Future<void> callGetWaktuSolatToday() async {
    double lat = locationProvider.currentLatitude ?? mapModel.defaultLat;
    double lng = locationProvider.currentLongitude ?? mapModel.defaultLng;
    await homeModel.getWaktuSolatToday(waktuSolatProvider, lat, lng);
    setState(() {});
  }

  void callGetCurrentWaktuSolat() {
    currentWaktuSolat = formatter.getCurrentWaktuSolat(
        waktuSolatProvider.waktuSolatTime, waktuSolatProvider.waktuSolatLabel);
    setState(() {});
  }

  Future<void> callGetAsmaUlHusna() async {
    await homeModel.getAsmaUlHusna(asmaUlHusnaProvider);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ScaffoldBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeHeader(
                  currentHijrahDate: timeProvider.hijrahDate,
                  currentTime: timeProvider.currentTime,
                  currentMeridiem: timeProvider.currentMeridiem,
                  currentLocation: locationProvider.currentLocationName,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          WaktuSolatCard(
                            today: homeModel.currentDay,
                            currentWaktuSolat: currentWaktuSolat,
                            subuh: waktuSolatProvider.subuh,
                            syuruk: waktuSolatProvider.syuruk,
                            zohor: waktuSolatProvider.zohor,
                            asar: waktuSolatProvider.asar,
                            maghrib: waktuSolatProvider.maghrib,
                            isyak: waktuSolatProvider.isyak,
                          ),
                          const SizedBox(height: 10),
                          AsmaUlHusnaCard(
                            asmaUlHusnaProvider: asmaUlHusnaProvider,
                            homeModel: homeModel,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 8.0,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFF7DC8E0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "assets/images/quran.png",
                                            fit: BoxFit.cover,
                                            opacity:
                                                const AlwaysStoppedAnimation(
                                                    0.5),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                "NUZUL QURAN",
                                                style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.staatliches()
                                                          .fontFamily,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: const [
                                                    Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 5.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "144",
                                                style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.staatliches()
                                                          .fontFamily,
                                                  fontSize: 60,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: const [
                                                    Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 5.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "days",
                                                style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: const [
                                                    Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 5.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 8.0,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(
                                          255, 232, 241, 167),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "assets/images/ketupat.png",
                                            fit: BoxFit.cover,
                                            opacity:
                                                const AlwaysStoppedAnimation(
                                                    0.5),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                "EID FITR",
                                                style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.staatliches()
                                                          .fontFamily,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: const [
                                                    Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 5.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "5",
                                                style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.staatliches()
                                                          .fontFamily,
                                                  fontSize: 60,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: const [
                                                    Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 5.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "days",
                                                style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: const [
                                                    Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 5.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                      const SizedBox(height: 100)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
