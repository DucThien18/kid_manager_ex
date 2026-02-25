import 'package:flutter/material.dart';
import 'package:kid_manager/widgets/common/social_login_button.dart';

import '../../core/app_colors.dart';
import '../../widgets/app/app_button.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  final _policyStyle = const TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    height: 2,
    letterSpacing: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    // Theo spec bạn đưa:
    return Scaffold(
      backgroundColor: AppColors.surface, // #FFFFFF
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bắt Đầu Ngay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0.75,
                  letterSpacing: 0.50,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: 180,
                child: Text(
                  'Tiếp tục với ứng dụng ngay thôi!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SocialLoginButton(
                text: 'Tiếp tục với Google',
                iconAsset: 'assets/icons/google.svg',
                onTap: () {
                  // TODO: Google login
                },
              ),

              const SizedBox(height: 16),

              SocialLoginButton(
                text: 'Tiếp tục với Facebook',
                iconAsset: 'assets/icons/facebook.svg',
                onTap: () {
                  // TODO: Facebook login
                },
              ),

              const SizedBox(height: 16),

              SocialLoginButton(
                text: 'Tiếp tục với Apple',
                iconAsset: 'assets/icons/apple.svg',
                onTap: () {
                  // TODO: Apple login
                },
              ),

              const SizedBox(height: 16),

              SocialLoginButton(
                text: 'Tiếp tục với số điện thoại',
                iconAsset: 'assets/icons/mobile.svg',
                onTap: () {
                  // TODO: Phone login
                },
              ),

              const SizedBox(height: 29),
              Container(
                width: 147.78,
                height: 0.83,
                decoration: BoxDecoration(color: const Color(0x331A1A1A)),
              ),

              const SizedBox(height: 24.17),

              // Actions
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      width: 360,
                      height: 60,
                      text: 'Đăng nhập',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      // Primary
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Đăng ký',
                      width: 360,
                      height: 60,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      // Outline uses primary color by default (trong AppButton mình đã set)
                      backgroundColor: AppColors.primarySoft,
                      foregroundColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
              Container(
                width: 147.78,
                height: 1,
                decoration: BoxDecoration(color: const Color(0x331A1A1A)),
              ),
              
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chính sách bảo mật', style: _policyStyle),
                  const SizedBox(width: 8),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF8E8E93),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(width: 4, height: 4),
                  ),
                  const SizedBox(width: 8),
                  Text('Điều khoản dịch vụ', style: _policyStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
