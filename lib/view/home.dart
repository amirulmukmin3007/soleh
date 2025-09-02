import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
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

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late HomeModel homeModel;
  late TimeProvider timeProvider;
  late LocationProvider locationProvider;
  late WaktuSolatProvider waktuSolatProvider;
  late AsmaUlHusnaProvider asmaUlHusnaProvider;
  late MapModel mapModel;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Formatter formatter = Formatter();
  String currentWaktuSolat = '';
  Timer? timer;
  Timer? minuteTimer;

  // Loading states
  bool isLocationLoading = true;
  bool isWaktuSolatLoading = true;
  bool isAsmaUlHusnaLoading = true;
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    homeModel = HomeModel();
    timeProvider = TimeProvider();
    locationProvider = LocationProvider();
    waktuSolatProvider = WaktuSolatProvider();
    asmaUlHusnaProvider = AsmaUlHusnaProvider();
    mapModel = MapModel();

    // Initialize animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));

    homeModel
        .getHijrahDate()
        .then((value) => timeProvider.updateHijrahDate(value));
    initialize();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          callGetTime();
        });
      },
    );

    minuteTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
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

    // Start the fade-up animation after initialization
    setState(() {
      isInitializing = false;
    });
    _fadeAnimationController.forward();
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
    setState(() {
      isLocationLoading = true;
    });
    await homeModel.getLiveLocation(locationProvider);
    setState(() {
      isLocationLoading = false;
    });
  }

  Future<void> callGetLocationName() async {
    double lat = locationProvider.currentLatitude ?? mapModel.defaultLat;
    double lng = locationProvider.currentLongitude ?? mapModel.defaultLng;
    await homeModel.getLocationName(locationProvider, lat, lng);
    setState(() {});
  }

  Future<void> callGetWaktuSolatToday() async {
    setState(() {
      isWaktuSolatLoading = true;
    });
    double lat = locationProvider.currentLatitude ?? mapModel.defaultLat;
    double lng = locationProvider.currentLongitude ?? mapModel.defaultLng;
    await homeModel.getWaktuSolatToday(waktuSolatProvider, lat, lng);
    setState(() {
      isWaktuSolatLoading = false;
    });
  }

  void callGetCurrentWaktuSolat() {
    currentWaktuSolat = formatter.getCurrentWaktuSolat(
        waktuSolatProvider.waktuSolatTime, waktuSolatProvider.waktuSolatLabel);
    setState(() {});
  }

  Future<void> callGetAsmaUlHusna() async {
    setState(() {
      isAsmaUlHusnaLoading = true;
    });
    await homeModel.getAsmaUlHusna(asmaUlHusnaProvider);
    setState(() {
      isAsmaUlHusnaLoading = false;
    });
  }

  Widget _buildWaktuSolatCardShimmer() {
    return Container(
      height: 200, // Adjust based on your card height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Shimmer(
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white70],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildAsmaUlHusnaCardShimmer() {
    return Container(
      height: 120, // Adjust based on your card height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Shimmer(
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white70],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required Widget child, required int index}) {
    return AnimatedBuilder(
      animation: _fadeAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    minuteTimer?.cancel();
    _fadeAnimationController.dispose();
    super.dispose();
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
                // Header with shimmer for location if loading
                isLocationLoading
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        child: Shimmer(
                          gradient: const LinearGradient(
                            colors: [Colors.white, Colors.white70],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      )
                    : HomeHeader(
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
                          // Waktu Solat Card with shimmer and animation
                          isWaktuSolatLoading || isInitializing
                              ? _buildWaktuSolatCardShimmer()
                              : _buildAnimatedCard(
                                  index: 0,
                                  child: WaktuSolatCard(
                                    today: homeModel.currentDay,
                                    currentWaktuSolat: currentWaktuSolat,
                                    subuh: waktuSolatProvider.subuh,
                                    syuruk: waktuSolatProvider.syuruk,
                                    zohor: waktuSolatProvider.zohor,
                                    asar: waktuSolatProvider.asar,
                                    maghrib: waktuSolatProvider.maghrib,
                                    isyak: waktuSolatProvider.isyak,
                                  ),
                                ),
                          const SizedBox(height: 10),
                          // Asma Ul Husna Card with shimmer and animation
                          isAsmaUlHusnaLoading || isInitializing
                              ? _buildAsmaUlHusnaCardShimmer()
                              : _buildAnimatedCard(
                                  index: 1,
                                  child: AsmaUlHusnaCard(
                                    asmaUlHusnaProvider: asmaUlHusnaProvider,
                                    homeModel: homeModel,
                                  ),
                                ),
                          const SizedBox(height: 10),
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
