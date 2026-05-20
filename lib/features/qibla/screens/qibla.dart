import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:soleh/features/home/bloc/home_bloc.dart';
import 'package:soleh/features/qibla/cubit/qibla_direction_cubit.dart';
import 'package:vibration/vibration.dart';

class QiblaScreen extends StatefulWidget {
  static const routeName = '/qibla';
  const QiblaScreen({super.key, required this.isActive});

  final bool isActive;

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection;
  bool _isAligned = false;
  bool _hasVibrated = false;
  bool _isActive = false;

  static const double alignmentThreshold = 5.0;

  @override
  void initState() {
    super.initState();
    _checkBlocLocation();
  }

  void _checkBlocLocation() {
    final homeState = context.read<HomeBloc>().state;
    if (homeState is HomeLoaded) {
      context.read<QiblaDirectionCubit>().updateQiblaDirection(
            homeState.userLatitude,
            homeState.userLongitude,
          );
    }
  }

  @override
  void didUpdateWidget(QiblaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      if (kDebugMode) {
        log('Qibla is Active');
      }
      _onActive();
    } else if (oldWidget.isActive && !widget.isActive) {
      if (kDebugMode) {
        log('Qibla is Inactive');
      }
      _onInactive();
    }
  }

  void _onActive() {
    // Refresh location when screen becomes active
    _checkBlocLocation();
    setState(() {
      _isActive = true;
    });
  }

  void _onInactive() {
    setState(() {
      _isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded && _qiblaDirection == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<QiblaDirectionCubit>().updateQiblaDirection(
                  state.userLatitude,
                  state.userLongitude,
                );
          });
        }

        final hasLocation = state is HomeLoaded;

        return Scaffold(
          body: BlocBuilder<QiblaDirectionCubit, QiblaDirectionState>(
            builder: (context, state) {
              _qiblaDirection = state.qiblaDirection;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1a472a),
                      Color(0xFF2d5f3f),
                      Color(0xFF1a472a),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: hasLocation && _isActive
                      ? _buildCompassView()
                      : _buildNoLocationMessage(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNoLocationMessage() {
    return Center(
      child: Text(
        'Location not available. Please enable location from home screen.',
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCompassView() {
    return Column(
      children: [
        SizedBox(height: 32),

        SizedBox(height: 8),

        if (_qiblaDirection != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.explore,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '${_qiblaDirection!.toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

        Spacer(),
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isAligned
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FlutterIslamicIcons.kaaba,
                size: 30,
                color: Color(0xFFFFD700),
              ),
            ),
            Container(
                height: 10,
                width: 5,
                color: _isAligned
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.1)),
            // Compass with arrow
            _buildCompass(),
          ],
        ),

        Spacer(),

        // Instructions
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white70,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Hold your phone flat and rotate until the arrow points upward',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget('Error reading compass: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                ),
                SizedBox(height: 16),
                Text(
                  'Initializing compass...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          );
        }

        if (_qiblaDirection == null) {
          return _buildErrorWidget('Calculating Qibla direction...');
        }

        double? heading = snapshot.data?.heading;

        if (heading == null) {
          return _buildErrorWidget('Compass not available');
        }

        double qiblaAngle = _qiblaDirection! - heading;

        while (qiblaAngle > 180) {
          qiblaAngle -= 360;
        }
        while (qiblaAngle < -180) {
          qiblaAngle += 360;
        }

        bool isCurrentlyAligned = qiblaAngle.abs() <= alignmentThreshold;

        if (isCurrentlyAligned && !_hasVibrated) {
          _triggerVibration();
          _hasVibrated = true;
        } else if (!isCurrentlyAligned) {
          _hasVibrated = false; // Reset when out of alignment
        }

        if (_isAligned != isCurrentlyAligned) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _isAligned = isCurrentlyAligned);
            }
          });
        }

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring with degree markers
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isAligned
                        ? Color(0xFFFFD700)
                        : Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  painter: CompassRingPainter(),
                ),
              ),

              // Inner circle background with glow effect
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              // Rotating arrow
              Transform.rotate(
                angle: (qiblaAngle * (math.pi / 180)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Arrow pointing up
                    Icon(
                      Icons.navigation,
                      size: 100,
                      color: Color(0xFFFFD700),
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // "Qibla" text under arrow
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'QIBLA',
                        style: TextStyle(
                          color: Color(0xFF1a472a),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Alignment indicator badge
              if (_isAligned)
                Positioned(
                  bottom: 20,
                  child: AnimatedOpacity(
                    opacity: _isAligned ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFC1EEB7),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFC1EEB7).withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF1a472a),
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'ALIGNED',
                            style: TextStyle(
                              color: Color(0xFF1a472a),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white60,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _checkBlocLocation,
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFD700),
              foregroundColor: Color(0xFF1a472a),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _triggerVibration() async {
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      if (kDebugMode) print('Vibration error: $e');
    }
  }
}

// Custom painter for compass ring with markers
class CompassRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw degree markers
    for (int i = 0; i < 360; i += 10) {
      final angle = i * math.pi / 180;
      final isMainDirection = i % 90 == 0;
      final isMajorTick = i % 30 == 0;

      final startRadius = isMainDirection
          ? radius - 20
          : (isMajorTick ? radius - 15 : radius - 10);
      final endRadius = radius - 5;

      final start = Offset(
        center.dx + startRadius * math.cos(angle - math.pi / 2),
        center.dy + startRadius * math.sin(angle - math.pi / 2),
      );

      final end = Offset(
        center.dx + endRadius * math.cos(angle - math.pi / 2),
        center.dy + endRadius * math.sin(angle - math.pi / 2),
      );

      paint.strokeWidth = isMainDirection ? 3 : (isMajorTick ? 2 : 1);
      paint.color = isMainDirection
          ? Color(0xFFFFD700).withValues(alpha: 0.6)
          : Colors.white.withValues(alpha: isMajorTick ? 0.4 : 0.2);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
