import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_manager/core/app_colors.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:kid_manager/widgets/auth/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    // TODO: call API send OTP
    // Navigator.push(... to OTP screen)
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8),
                child:
                    // Back icon
                    SvgPicture.asset(
                      'assets/icons/back.svg',
                      width: 17,
                      height: 12.5,
                    ),
              ),

              const SizedBox(height: 24),

              // Title + description
              Padding(
                padding: EdgeInsets.only(left: 14),
                child: SizedBox(
                  width: 289,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ĐẶT LẠI \nMẬT KHẨU MỚI',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.42,
                          letterSpacing: -0.19,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Điền mật khẩu mới của bạn!',
                        style: TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              AuthTextField(
                label: 'Mật khẩu mới',
                controller: _passwordController,
                hintText: 'Nhập mật khẩu',
                keyboardType: TextInputType.text,
                obscureText: true,
                isPassword: true,
                prefixSvg: 'assets/icons/lock.svg',
              ),
              
              AuthTextField(
                label: 'Nhập lại mật khẩu',
                controller: _passwordController,
                hintText: 'Nhập lại mật khẩu',
                keyboardType: TextInputType.text,
                obscureText: true,
                isPassword: true,
                prefixSvg: 'assets/icons/lock.svg',
              ),

              const Spacer(),

              // Button bottom
              AppButton(
                height: 60,
                text: 'Hoàn tất',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                onPressed: () {},
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
