import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoad extends StatelessWidget {
  const ShimmerLoad({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double height;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white.withValues(alpha: 0.1),
      ),
      child: Shimmer(
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white70],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
