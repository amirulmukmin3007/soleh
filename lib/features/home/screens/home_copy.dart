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

  Widget _shimmerAzanCard() {
    return Container(
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
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
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
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return _shimmerScreen();
            } else if (state is HomeLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_fadeAnimationController.isCompleted) {
                  _fadeAnimationController.forward();
                }
              });
              return _displayScreen(context, state);
            } else {
              return Container(
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
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _shimmerScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _shimmerAzanCard(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    ShimmerBox(height: 200, width: double.infinity),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ShimmerBox(height: 100, width: 60),
                        ShimmerBox(height: 100, width: 60),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ShimmerBox(height: 200, width: double.infinity),
                    const SizedBox(height: 10),
                    ShimmerBox(height: 120, width: double.infinity),
                    const SizedBox(height: 10),
                    ShimmerBox(height: 200, width: double.infinity),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 100)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _displayScreen(BuildContext context, HomeLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).padding.top,
            color: ColorTheme.primary,
          ),
          HomeHeader(
            currentHijrahDate: state.hijrahDate.currentHijrahDate,
            currentTime: currentTime,
            currentMeridiem: currentMeridiem,
            currentLocation: state.locationName,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildAnimatedCard(
                      index: 0,
                      child: WaktuSolatCard(
                        today: state.hijrahDate.currentDay,
                        currentWaktuSolat: state.currentWaktuSolat,
                        subuh: state.prayerTimes.subuh,
                        syuruk: state.prayerTimes.syuruk,
                        zohor: state.prayerTimes.zohor,
                        asar: state.prayerTimes.asar,
                        maghrib: state.prayerTimes.maghrib,
                        isyak: state.prayerTimes.isyak,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAnimatedCard(
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
                    _buildAnimatedCard(
                      index: 2,
                      child: AsmaUlHusnaCard2(
                        auhMeaning: state.asmaUlHusna.auhMeaning,
                        auhAR: state.asmaUlHusna.auhAR,
                        auhEN: state.asmaUlHusna.auhEN,
                        auhNum: state.asmaUlHusna.auhNum,
                        dayPicture: state.dayPicture, // Pass the day picture
                        onRefresh: () {
                          // Reset animation
                          _fadeAnimationController.reset();
                          // Refresh data
                          context.read<HomeBloc>().add(HomeRefreshDataEvent());
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAnimatedCard(
                      index: 3,
                      child: ZikirDailyCard(
                        title: state.zikirHarian.title,
                        imageUrl: state.zikirHarian.imageUrl,
                        day: state.zikirHarian.day,
                        dayName: state.zikirHarian.dayName,
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
    );
  }
}
