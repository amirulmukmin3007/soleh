import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:soleh/features/home/bloc/home_bloc.dart';
import 'package:soleh/features/home/repositories/home_repository.dart';
import 'package:soleh/features/map/bloc/map_bloc.dart';
import 'package:soleh/features/map/repositories/map_repository.dart';
import 'package:soleh/splashscreen.dart';
import 'package:soleh/themes/fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(repository: HomeRepository()),
        ),
        BlocProvider(
          create: (context) => MapBloc(repository: MapRepository()),
        ),
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(fontFamily: FontTheme().fontFamily),
        debugShowCheckedModeBanner: false,
        title: 'Soleh App',
        home: SplashScreen(),
      ),
    );
  }
}
