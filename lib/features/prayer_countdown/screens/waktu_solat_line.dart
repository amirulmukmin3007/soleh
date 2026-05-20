import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleh/features/prayer_countdown/cubit/prayer_countdown_cubit.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

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
                const SizedBox(height: 30),
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
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              countdownState.timeRemaining,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 45,
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
          const Color(0xFF2BADB4),
        ],
      },
      'Asar': {
        'color': const Color(0xFFFF9717),
        'backgroundColor': [
          const Color(0xFF207197),
          const Color(0xFF2699CE),
          const Color.fromARGB(255, 30, 144, 196),
        ],
      },
      'Maghrib': {
        'color': const Color(0xFFFFB74D),
        'backgroundColor': [
          const Color(0xFF581DCE),
          const Color(0xFF5C2AC0),
          const Color(0xFF5D1BE1),
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

  List<dynamic> backgroundDeco = [
    {
      'name': 'Subuh',
      'decoration': [
        Positioned(
          top: 50,
          left: -20,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 70,
          left: 80,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          left: 100,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 80,
          right: -10,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 30,
          right: 100,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
      ]
    },
    {
      'name': 'Zohor',
      'decoration': [
        Positioned(
          top: 50,
          left: -20,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 70,
          left: 80,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          left: 100,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 80,
          right: -10,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 30,
          right: 100,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ]
    },
    {
      'name': 'Asar',
      'decoration': [
        Positioned(
          top: 50,
          left: -20,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 70,
          left: 80,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          left: 100,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 80,
          right: -10,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 30,
          right: 100,
          child: Icon(
            FluentIcons.cloud_16_filled,
            size: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ]
    },
    {
      'name': 'Maghrib',
      'decoration': [
        Positioned(
          top: 50,
          left: -20,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 70,
          left: 80,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          left: 100,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 80,
          right: -10,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 30,
          right: 100,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
      ]
    },
    {
      'name': 'Isyak',
      'decoration': [
        Positioned(
          top: 50,
          left: -20,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 70,
          left: 80,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          left: 100,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 80,
          right: -10,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 30,
          right: 100,
          child: Icon(
            FluentIcons.star_12_filled,
            size: 40,
            color: Colors.amber.withValues(alpha: 0.1),
          ),
        ),
      ]
    },
  ];

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

    final decoration = backgroundDeco.firstWhere(
      (deco) => deco['name'] == widget.currentWaktuSolat,
      orElse: () => {'name': '', 'decoration': []},
    );
    return List<Widget>.from(decoration['decoration'] ?? []);
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
    final padding = 20.0;
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
            fontSize: isActive ? 15.0 : 13.0,
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
            fontSize: isActive ? 13.0 : 11.0,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w800,
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
