import 'package:flutter/material.dart';

class GoogleBlueDot extends StatelessWidget {
  final double accuracy; // meters

  const GoogleBlueDot({
    super.key,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (accuracy / 2).clamp(20.0, 80.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        // accuracy circle
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.18),
            shape: BoxShape.circle,
          ),
        ),

        // white border
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),

        // blue dot
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Color(0xFF1A73E8), // Google blue
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
