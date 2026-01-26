import 'package:flutter/material.dart';

class ModernBuffer extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const ModernBuffer({
    super.key,
    this.size = 60,
    this.strokeWidth = 4,
  });

  @override
  State<ModernBuffer> createState() => _ModernBufferState();
}

class _ModernBufferState extends State<ModernBuffer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const SweepGradient(
            colors: [
              Color(0xFF6366F1),
              Color(0xFFA855F7),
              Color(0xFFEC4899),
              Colors.transparent,
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.strokeWidth),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0A0E27),
            ),
          ),
        ),
      ),
    );
  }
}

class PulsingDotsBuffer extends StatefulWidget {
  const PulsingDotsBuffer({super.key});

  @override
  State<PulsingDotsBuffer> createState() => _PulsingDotsBufferState();
}

class _PulsingDotsBufferState extends State<PulsingDotsBuffer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = i * 0.2;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = 0.6 + (0.4 * (1 - (value * 2 - 1).abs()));

            return Transform.scale(
              scale: scale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6366F1).withOpacity(scale),
                      Color(0xFFA855F7).withOpacity(scale),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6366F1).withOpacity(0.5 * scale),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
