import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:soleh/features/calendar/bloc/calendar_bloc.dart';
import 'package:soleh/features/calendar/repositories/calendar_repository.dart';
import 'package:soleh/features/home/bloc/home_bloc.dart';
import 'package:soleh/features/home/repositories/home_repository.dart';
import 'package:soleh/features/map/bloc/map_bloc.dart';
import 'package:soleh/features/map/repositories/map_repository.dart';
import 'package:soleh/features/prayer_countdown/cubit/prayer_countdown_cubit.dart';
import 'package:soleh/features/qibla/cubit/qibla_direction_cubit.dart';
import 'package:soleh/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:soleh/themes/theme_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    DevicePreview(
      enabled: kDebugMode ? false : false,
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
        // Cubit
        BlocProvider(
          create: (context) => PrayerCountdownCubit(),
        ),
        BlocProvider(
          create: (context) => QiblaDirectionCubit(),
        ),
        // Bloc
        BlocProvider(
          create: (context) => HomeBloc(repository: HomeRepository()),
        ),
        BlocProvider(
          create: (context) => MapBloc(repository: MapRepository()),
        ),
        BlocProvider(
          create: (context) => CalendarBloc(repository: CalendarRepository()),
        ),
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        title: 'Soleh App',
        home: SplashScreen(),
      ),
    );
  }
}
