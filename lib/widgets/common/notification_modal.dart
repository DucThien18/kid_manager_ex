import 'package:flutter/material.dart';

class NotificationModal extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback? onBackgroundTap;

  const NotificationModal({
    super.key,
    required this.child,
    this.width = 339,
    this.height = 291,
    this.onBackgroundTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // BACKGROUND
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBackgroundTap,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0x66000000),
            ),
          ),

          // MODAL BOX (CHẶN TAP XUYÊN)
          AbsorbPointer(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}