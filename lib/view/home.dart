import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/model/home_model.dart';
import 'package:soleh/shared/component/asmaulhusna_card.dart';
import 'package:soleh/shared/component/home_header.dart';
import 'package:soleh/shared/component/scaffoldbackground.dart';
import 'package:soleh/shared/component/shimmer.dart';
import 'package:soleh/shared/component/waktusolat_card.dart';
import 'package:soleh/shared/functions/formatter.dart';
import 'package:location/location.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/view/masjid_location.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeModel homeModel = HomeModel();
  Formatter formatter = Formatter();
  Timer? timer;

  @override
  void initState() {
    homeModel.getHijrahDate().then((value) => homeModel.setDate = value);
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            homeModel.currentTime = formatter.getTime();
            homeModel.currentMeridiem = formatter.getMeridiem();
          },
        );
      },
    );
    homeModel.currentLocation = getLiveLocation();
    homeModel.getAsmaUlHusna();
    print("Current latlng : ${homeModel.currentLat}, ${homeModel.currentLng}");
    super.initState();
  }

  String getLiveLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      homeModel.currentLat = location.latitude!;
      homeModel.currentLng = location.longitude!;
      var locationName =
          homeModel.getLocationName(homeModel.currentLat, homeModel.currentLng);
      homeModel.getWaktuSolatToday(homeModel.currentLat, homeModel.currentLng);
      print(
          "Current latlng : ${homeModel.currentLat}, ${homeModel.currentLng}");

      return locationName;
    });
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MasjidLocation();
          }));
        });
      }),
      backgroundColor: Colors.transparent,
      body: ScaffoldBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeHeader(
                  currentHijrahDate: homeModel.currentHijrahDate,
                  currentTime: homeModel.currentTime,
                  currentMeridiem: homeModel.currentMeridiem,
                  currentLocation: homeModel.currentLocation,
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
                            subuh: homeModel.subuhTime,
                            zohor: homeModel.zohorTime,
                            asar: homeModel.asarTime,
                            maghrib: homeModel.maghribTime,
                            isyak: homeModel.isyakTime,
                            homeModel: homeModel,
                            formatter: formatter,
                          ),
                          const SizedBox(height: 10),
                          AsmaUlHusnaCard(homeModel: homeModel),
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
