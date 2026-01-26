import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleh/shared/bloc/prayer_countdown/prayer_countdown_cubit.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:soleh/shared/component/circlebutton.dart';
import 'package:soleh/shared/component/shimmer.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class WaktuSolatCard extends StatefulWidget {
  const WaktuSolatCard({
    super.key,
    required this.currentWaktuSolat,
    required this.subuh,
    required this.syuruk,
    required this.zohor,
    required this.asar,
    required this.maghrib,
    required this.isyak,
    required this.today,
  });

  final String currentWaktuSolat;
  final String subuh;
  final String syuruk;
  final String zohor;
  final String asar;
  final String maghrib;
  final String isyak;
  final String today;

  @override
  State<WaktuSolatCard> createState() => _WaktuSolatState();
}

class _WaktuSolatState extends State<WaktuSolatCard> {
  List<String> waktuSolatList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            children: [
              Center(
                child: widget.today == ''
                    ? const ShimmerLoad(height: 30, width: 200)
                    : Text(
                        widget.today,
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorTheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
              const Divider(
                color: ColorTheme.primary,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleButton(
                    iconData: FluentIcons.weather_sunny_low_24_regular,
                    buttonColor: widget.currentWaktuSolat == 'Subuh'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Subuh'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Subuh',
                    timeText: widget.subuh,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_sunny_16_regular,
                    buttonColor: widget.currentWaktuSolat == 'Zohor'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Zohor'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Zohor',
                    timeText: widget.zohor,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_sunny_high_48_regular,
                    buttonColor: widget.currentWaktuSolat == 'Asar'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Asar'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Asar',
                    timeText: widget.asar,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData:
                        FluentIcons.weather_partly_cloudy_night_24_regular,
                    buttonColor: widget.currentWaktuSolat == 'Maghrib'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Maghrib'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Maghrib',
                    timeText: widget.maghrib,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                  CircleButton(
                    iconData: FluentIcons.weather_moon_16_regular,
                    buttonColor: widget.currentWaktuSolat == 'Isyak'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    iconColor: widget.currentWaktuSolat == 'Isyak'
                        ? Colors.amber[800]!
                        : ColorTheme.primary,
                    waktuText: 'Isyak',
                    timeText: widget.isyak,
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WaktuSolatLineCard extends StatefulWidget {
  const WaktuSolatLineCard({
    super.key,
    required this.currentWaktuSolat,
    required this.subuh,
    required this.syuruk,
    required this.zohor,
    required this.asar,
    required this.maghrib,
    required this.isyak,
    required this.today,
  });

  final String currentWaktuSolat;
  final String subuh;
  final String syuruk;
  final String zohor;
  final String asar;
  final String maghrib;
  final String isyak;
  final String today;

  @override
  State<WaktuSolatLineCard> createState() => _WaktuSolatLineCardState();
}

class _WaktuSolatLineCardState extends State<WaktuSolatLineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    final prayerTimes = {
      'subuh': widget.subuh,
      'syuruk': widget.syuruk,
      'zohor': widget.zohor,
      'asar': widget.asar,
      'maghrib': widget.maghrib,
      'isyak': widget.isyak,
    };

    context.read<PrayerCountdownCubit>().startCountdown(
          currentPrayer: widget.currentWaktuSolat,
          prayerTimes: prayerTimes,
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerTimes = _getPrayerTimes();
    final backgroundColors = _getCurrentBackgroundColors();
    final decorationWidgets = _getCurrentBackgroundDecoration();

    return Container(
      height: 320,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundColors,
        ),
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: backgroundColors[1].withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          ...decorationWidgets,
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // OPTIMIZATION: Static header (doesn't need to rebuild)
                _buildStaticHeader(),

                const SizedBox(height: 30),

                // OPTIMIZATION: Only countdown rebuilds
                _buildCountdownSection(),

                // OPTIMIZATION: Prayer line only rebuilds on animation
                // Not affected by countdown updates
                Expanded(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: PrayerLinePainter(
                          prayerTimes: prayerTimes,
                          currentPrayer: widget.currentWaktuSolat,
                          animation: _animationController.value,
                        ),
                        child: Container(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // OPTIMIZATION: Separate static header into its own widget
  Widget _buildStaticHeader() {
    final prayerColor = _getPrayerColors()[widget.currentWaktuSolat];

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (prayerColor?['color'] as Color? ?? Colors.amber)
                .withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.access_time,
            color: prayerColor?['color'] as Color? ?? Colors.amber,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prayer Times',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.today.isEmpty ? 'Loading...' : widget.today,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // OPTIMIZATION: Isolated countdown that rebuilds independently
  Widget _buildCountdownSection() {
    return BlocBuilder<PrayerCountdownCubit, PrayerCountdownState>(
      // CRITICAL: Only rebuild when these specific fields change
      buildWhen: (previous, current) =>
          previous.timeRemaining != current.timeRemaining ||
          previous.nextPrayer != current.nextPrayer,
      builder: (context, countdownState) {
        return Column(
          children: [
            Text(
              'TIME UNTIL ${countdownState.nextPrayer.toUpperCase()}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              countdownState.timeRemaining,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getPrayerTimes() {
    final prayerColors = _getPrayerColors();
    return [
      {
        'name': 'Subuh',
        'time': widget.subuh,
        'icon': Icons.wb_twilight,
        'color': prayerColors['Subuh']!['color'],
      },
      {
        'name': 'Zohor',
        'time': widget.zohor,
        'icon': Icons.wb_sunny,
        'color': prayerColors['Zohor']!['color'],
      },
      {
        'name': 'Asar',
        'time': widget.asar,
        'icon': Icons.light_mode,
        'color': prayerColors['Asar']!['color'],
      },
      {
        'name': 'Maghrib',
        'time': widget.maghrib,
        'icon': Icons.nights_stay,
        'color': prayerColors['Maghrib']!['color'],
      },
      {
        'name': 'Isyak',
        'time': widget.isyak,
        'icon': Icons.nightlight,
        'color': prayerColors['Isyak']!['color'],
      },
    ];
  }

  Map<String, Map<String, dynamic>> _getPrayerColors() {
    return {
      'Subuh': {
        'color': const Color(0xFFFFB74D),
        'backgroundColor': [
          const Color(0xFF1a237e),
          const Color(0xFF283593),
          const Color(0xFF3949ab),
        ],
      },
      'Zohor': {
        'color': const Color(0xFFFF9717),
        'backgroundColor': [
          const Color(0xFF209197),
          const Color(0xFF26AEB5),
          const Color(0xFF3BECF6),
        ],
      },
      'Asar': {
        'color': const Color(0xFFFF9717),
        'backgroundColor': [
          const Color(0xFF207197),
          const Color(0xFF2699CE),
          const Color(0xFF23A7E4),
        ],
      },
      'Maghrib': {
        'color': const Color(0xFFFFB74D),
        'backgroundColor': [
          const Color(0xFF9F3901),
          const Color(0xFFB25900),
          const Color(0xFFDB870A),
        ],
      },
      'Isyak': {
        'color': const Color(0xFFFFB74D),
        'backgroundColor': [
          const Color(0xFF191C21),
          const Color(0xFF323940),
          const Color(0xFF5A6570),
        ],
      },
    };
  }

  List<Color> _getCurrentBackgroundColors() {
    if (widget.currentWaktuSolat == 'Syuruk') {
      return [
        ColorTheme.primary,
        ColorTheme.primary,
        ColorTheme.primary,
      ];
    }

    final colors = _getPrayerColors()[widget.currentWaktuSolat];
    if (colors != null && colors['backgroundColor'] != null) {
      return List<Color>.from(colors['backgroundColor']);
    }

    return [
      const Color(0xFF1a237e),
      const Color(0xFF283593),
      const Color(0xFF3949ab),
    ];
  }

  List<Widget> _getCurrentBackgroundDecoration() {
    if (widget.currentWaktuSolat == 'Syuruk') {
      return [];
    }
    return [];
  }
}

class PrayerLinePainter extends CustomPainter {
  final List<Map<String, dynamic>> prayerTimes;
  final String currentPrayer;
  final double animation;

  PrayerLinePainter({
    required this.prayerTimes,
    required this.currentPrayer,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 40.0;
    final lineY = size.height / 2;
    final lineWidth = size.width - (padding * 2);
    final spacing = lineWidth / (prayerTimes.length - 1);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(padding, lineY),
      Offset(size.width - padding, lineY),
      linePaint,
    );

    if (currentPrayer != 'Syuruk') {
      final currentIndex =
          prayerTimes.indexWhere((p) => p['name'] == currentPrayer);
      if (currentIndex >= 0) {
        final activeLinePaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(padding, lineY),
          Offset(padding + (spacing * currentIndex), lineY),
          activeLinePaint,
        );
      }
    }

    for (int i = 0; i < prayerTimes.length; i++) {
      final prayer = prayerTimes[i];
      final x = padding + (i * spacing);

      final isActive =
          currentPrayer != 'Syuruk' && prayer['name'] == currentPrayer;

      final prayerColor = prayer['color'] as Color;

      final scale = animation * (isActive ? 1.0 : 0.75);
      final iconSize = isActive ? 55.0 : 45.0;

      if (isActive) {
        final glowPaint = Paint()
          ..color = prayerColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

        canvas.drawCircle(
          Offset(x, lineY),
          (iconSize / 2 + 10) * scale,
          glowPaint,
        );
      }

      final circlePaint = Paint()
        ..color = isActive ? prayerColor : Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, lineY),
        (iconSize / 2) * scale,
        circlePaint,
      );

      final borderPaint = Paint()
        ..color = isActive
            ? prayerColor.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isActive ? 3 : 2;

      canvas.drawCircle(
        Offset(x, lineY),
        (iconSize / 2) * scale,
        borderPaint,
      );

      final iconData = prayer['icon'] as IconData;
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            color: isActive ? Colors.white : const Color(0xFF404040),
            fontSize: (isActive ? 32.0 : 25.0) * scale,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          x - iconPainter.width / 2,
          lineY - iconPainter.height / 2,
        ),
      );

      final timePainter = TextPainter(
        text: TextSpan(
          text: prayer['time'],
          style: TextStyle(
            color: Colors.white,
            fontFamily: FontTheme().fontFamily,
            fontSize: isActive ? 15.0 : 11.0,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      timePainter.layout();
      timePainter.paint(
        canvas,
        Offset(
          x - timePainter.width / 2,
          lineY + (iconSize / 2) * scale + 10,
        ),
      );

      final namePainter = TextPainter(
        text: TextSpan(
          text: prayer['name'],
          style: TextStyle(
            color:
                isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
            fontFamily: FontTheme().fontFamily,
            fontSize: isActive ? 13.0 : 10.0,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      namePainter.layout();
      namePainter.paint(
        canvas,
        Offset(
          x - namePainter.width / 2,
          lineY + (iconSize / 2) * scale + 27,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(PrayerLinePainter oldDelegate) {
    return oldDelegate.currentPrayer != currentPrayer ||
        oldDelegate.animation != animation;
  }
}
