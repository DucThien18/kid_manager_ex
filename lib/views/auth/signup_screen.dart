import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_manager/core/validators.dart';
import 'package:kid_manager/views/auth/login_screen.dart';
import 'package:kid_manager/widgets/auth/auth_text_field.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/alert_service.dart';
import '../../viewmodels/auth_vm.dart';
import '../../widgets/app/app_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool agreeClause = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignUpPressed() async {
    final vm = context.read<AuthVM>();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();
    // Validate
    if (email.isEmpty || password.isEmpty) {
      AlertService.showSnack('Vui lòng nhập đầy đủ thông tin', isError: true);
      return;
    }

    if (!Validators.isValidEmail(email)) {
      AlertService.showSnack('Email không hợp lệ', isError: true);
      return;
    }

    if (email.isEmpty || password.isEmpty || confirm.isEmpty || !agreeClause) {
      AlertService.showSnack('Vui lòng nhập đầy đủ thông tin', isError: true);
      return;
    }
    if (password != confirm) {
      AlertService.showSnack('Mật khẩu xác nhận không khớp', isError: true);
      return;
    }

    final ok = await vm.register(email, password);
    if (!ok) {
      AlertService.error(message: vm.error ?? 'Đăng ký thất bại');
      return;
    }

    // 🎉 Thành công
    AlertService.showSnack('Đăng ký thành công 🎉', isError: false);
  }

  @override
  Widget build(BuildContext context) {
    // Theo spec bạn đưa:
    return Scaffold(
      backgroundColor: AppColors.surface, // #FFFFFF
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                  ), // đổi 16 → 20/24 tuỳ bạn
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 266,
                        child: Text(
                          'ĐĂNG KÝ\nTÀI KHOẢN NGAY',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.42,
                            letterSpacing: -0.19,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 266,
                        child: Text(
                          'Kiểm tra và quản lí con của bạn!',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                AuthTextField(
                  label: 'Email',
                  controller: _emailCtrl,
                  hintText: 'Nhập email',
                  keyboardType: TextInputType.emailAddress,
                  prefixSvg: 'assets/icons/user.svg',
                ),
                AuthTextField(
                  label: 'Mật khẩu',
                  controller: _passwordCtrl,
                  hintText: 'Nhập mật khẩu',
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  isPassword: true,
                  prefixSvg: 'assets/icons/lock.svg',
                ),
                AuthTextField(
                  label: 'Nhập lại mật khẩu',
                  controller: _confirmCtrl,
                  hintText: 'Nhập mật khẩu',
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  isPassword: true,
                  prefixSvg: 'assets/icons/lock.svg',
                ),

                Padding(
                  padding: const EdgeInsets.all(4),
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                agreeClause = !agreeClause;
                              });
                            },
                            behavior: HitTestBehavior
                                .opaque, // 👈 vẫn bấm được cả vùng
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Checkbox
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: agreeClause
                                        ? const Color(0xFF3A7DFF)
                                        : Colors.transparent,
                                    border: Border.all(
                                      width: 2,
                                      color: agreeClause
                                          ? const Color(0xFF3A7DFF)
                                          : const Color(0xFF49454F),
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: agreeClause
                                      ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                // Text
                                const Text(
                                  'Đồng ý với điều khoản của chúng tôi',
                                  style: TextStyle(
                                    color: Color(0xFF6C7278),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    letterSpacing: -0.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        text: 'Đăng ký',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        onPressed: _onSignUpPressed,
                        // Primary
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 17),

                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0x331A1A1A), thickness: 0.83),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Hoặc',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0x331A1A1A), thickness: 0.83),
                    ),
                  ],
                ),

                const SizedBox(height: 17),

                Row(
                  children: [
                    Expanded(child: _socialBtn('assets/icons/google.svg')),
                    const SizedBox(width: 12),
                    Expanded(child: _socialBtn('assets/icons/facebook.svg')),
                    const SizedBox(width: 12),
                    Expanded(child: _socialBtn('assets/icons/apple.svg')),
                    const SizedBox(width: 12),
                    Expanded(child: _socialBtn('assets/icons/mobile.svg')),
                  ],
                ),

                const SizedBox(height: 61),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn đã có tài khoản, ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'đăng nhập',
                        style: TextStyle(
                          color: const Color(0xFF3A7DFF),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialBtn(String iconPath) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEFF0F6)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SvgPicture.asset(
          iconPath,
          width: 18,
          height: 18,
          placeholderBuilder: (_) => const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}
