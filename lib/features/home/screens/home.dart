import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:soleh/features/home/bloc/home_bloc.dart';
import 'package:soleh/shared/component/asmaulhusna_card.dart';
import 'package:soleh/shared/component/home_header.dart';
import 'package:soleh/shared/component/menu_box.dart';
import 'package:soleh/shared/component/scaffoldbackground.dart';
import 'package:soleh/shared/component/shimmer.dart';
import 'package:soleh/shared/component/waktusolat_card.dart';
import 'package:soleh/shared/component/zikir_harian_card.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:soleh/themes/colors.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Formatter formatter = Formatter();
  String currentTime = '';
  String currentMeridiem = '';
  Timer? timer;
  Timer? minuteTimer;

  List<Map<String, dynamic>> menus = [
    {
      'icon': FlutterIslamicIcons.solidTasbihHand,
      'title': 'Tasbih',
      'route': '/menu',
    },
    {
      'icon': FlutterIslamicIcons.calendar,
      'title': 'Kalendar',
      'route': '/menu',
    },
    {
      'icon': FlutterIslamicIcons.locationMosque,
      'title': 'Masjid',
      'route': '/menu',
    },
  ];

  @override
  void initState() {
    super.initState();

    currentTime = formatter.getTime();
    currentMeridiem = formatter.getMeridiem();

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

    context.read<HomeBloc>().add(HomeInitialEvent());

    // Update time every second
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          currentTime = formatter.getTime();
          currentMeridiem = formatter.getMeridiem();
        });
      },
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
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: ScaffoldBackground(
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeLoaded) {
                _fadeAnimationController.forward();
              }
            },
            builder: (context, state) {
              if (state is HomeInitial || state is HomeLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: ColorTheme.primary),
                      SizedBox(height: 16),
                      Text(
                        'Please allow location access to view prayer times',
                        style: TextStyle(color: ColorTheme.primary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header with shimmer for location if loading
                    state is HomeLoading
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
                        : state is HomeLoaded
                            ? HomeHeader(
                                currentHijrahDate:
                                    state.hijrahDate.currentHijrahDate,
                                currentTime: currentTime,
                                currentMeridiem: currentMeridiem,
                                currentLocation: state.locationName,
                              )
                            : Container(
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
                              ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              state is! HomeLoaded
                                  ? ShimmerCard(height: 200)
                                  : _buildAnimatedCard(
                                      index: 0,
                                      child: WaktuSolatCard(
                                        today: state.hijrahDate.currentDay,
                                        currentWaktuSolat:
                                            state.currentWaktuSolat,
                                        subuh: state.prayerTimes.subuh,
                                        syuruk: state.prayerTimes.syuruk,
                                        zohor: state.prayerTimes.zohor,
                                        asar: state.prayerTimes.asar,
                                        maghrib: state.prayerTimes.maghrib,
                                        isyak: state.prayerTimes.isyak,
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              state is! HomeLoaded
                                  ? ShimmerCard(height: 200)
                                  : _buildAnimatedCard(
                                      index: 1,
                                      child: Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: menus.map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: MenuBox(
                                              icon: item['icon'],
                                              label: item['title'],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              state is! HomeLoaded
                                  ? ShimmerCard(height: 120)
                                  : _buildAnimatedCard(
                                      index: 2,
                                      child: AsmaUlHusnaCard2(
                                        auhMeaning:
                                            state.asmaUlHusna.auhMeaning,
                                        auhAR: state.asmaUlHusna.auhAR,
                                        auhEN: state.asmaUlHusna.auhEN,
                                        auhNum: state.asmaUlHusna.auhNum,
                                        dayPicture: state
                                            .dayPicture, // Pass the day picture
                                        onRefresh: () {
                                          // Reset animation
                                          _fadeAnimationController.reset();
                                          // Refresh data
                                          context
                                              .read<HomeBloc>()
                                              .add(HomeRefreshDataEvent());
                                        },
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              state is! HomeLoaded
                                  ? ShimmerCard(height: 200)
                                  : _buildAnimatedCard(
                                      index: 3,
                                      child: ZikirDailyCard(
                                        title: state.zikirHarian.title,
                                        imageUrl: state.zikirHarian.imageUrl,
                                        day: state.zikirHarian.day,
                                        dayName: state.zikirHarian.dayName,
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              // Error state
                              if (state is HomeError)
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.error,
                                          size: 48, color: Colors.red),
                                      const SizedBox(height: 16),
                                      Text(
                                        state.message,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<HomeBloc>()
                                              .add(HomeInitialEvent());
                                        },
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 100)
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
