import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_text_styles.dart';

class ScheduleSuccessSheet extends StatefulWidget {
  final String message;

  const ScheduleSuccessSheet({
    super.key,
    required this.message,
  });

  @override
  State<ScheduleSuccessSheet> createState() =>
      _ScheduleSuccessSheetState();
}


class _ScheduleSuccessSheetState extends State<ScheduleSuccessSheet>
    with SingleTickerProviderStateMixin {

  Timer? _timer;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    /// Auto close sau 1.4s
    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Ellipse1.png',
                          width: 100,
                          height: 100,
                        ),
                        Image.asset(
                          'assets/images/Checkcircle.png',
                          width: 60,
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Hoàn thành',
                    style: AppTextStyles.scheduleSuccessTitle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.scheduleSuccessSubtitle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
