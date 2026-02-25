import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconAsset;
  final VoidCallback onTap;

  final double? width;
  final double height;
  final double borderRadius;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconAsset,
    required this.onTap,
    this.width = 360,
    this.height = 60,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Icon cố định bên trái
            Positioned(
              left: 24,
              child: SvgPicture.asset(
                iconAsset,
                width: 18,
                height: 18,
              ),
            ),

            // Text luôn ở giữa button
            Text(
              text,
              style: const TextStyle(
                color: AppColors.authText,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
