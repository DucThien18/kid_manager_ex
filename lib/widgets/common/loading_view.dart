import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color(0xB2686868), // overlay mờ
        child: Center(
          child: Container(
            width: 345,
            height: 201,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: const SvgLoading(),
            ),
          ),
        ),
      ),
    );
  }
}

class SvgLoading extends StatefulWidget {
  const SvgLoading({super.key});

  @override
  State<SvgLoading> createState() => _SvgLoadingState();
}

class _SvgLoadingState extends State<SvgLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
      child: SvgPicture.asset(
        'assets/icons/loading.svg',
        width: 60,
        height: 60,
      ),
    );
  }
}
