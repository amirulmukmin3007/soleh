import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soleh/features/home/bloc/home_bloc.dart';
import 'package:soleh/features/home/repositories/home_repository.dart';
import 'package:soleh/provider/asma_ul_husna_provider.dart';
import 'package:soleh/provider/location_provider.dart';
import 'package:soleh/provider/mosque_marker_provider.dart';
import 'package:soleh/provider/time_provider.dart';
import 'package:soleh/provider/waktu_solat_provider.dart';
import 'package:soleh/splashscreen.dart';
import 'package:soleh/themes/fonts.dart';
import 'package:soleh/view/bottomnavigationbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // runApp(const MainApp());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
    ChangeNotifierProvider<TimeProvider>(create: (_) => TimeProvider()),
    ChangeNotifierProvider<WaktuSolatProvider>(
        create: (_) => WaktuSolatProvider()),
    ChangeNotifierProvider<AsmaUlHusnaProvider>(
        create: (_) => AsmaUlHusnaProvider()),
    ChangeNotifierProvider<MosqueMarkerProvider>(
        create: (_) => MosqueMarkerProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(repository: HomeRepository()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: FontTheme().fontFamily),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: SplashScreen(),
      ),
    );
  }
}
