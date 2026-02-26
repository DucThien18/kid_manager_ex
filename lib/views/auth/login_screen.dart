import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_manager/core/app_colors.dart';
import 'package:kid_manager/core/validators.dart';
import 'package:kid_manager/helpers/json_helper.dart';
import 'package:kid_manager/models/login_session.dart';
import 'package:kid_manager/repositories/auth_repository.dart';
import 'package:kid_manager/services/storage_service.dart';
import 'package:kid_manager/views/auth/forgot_pass_screen.dart';
import 'package:kid_manager/views/auth/signup_screen.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:kid_manager/widgets/auth/auth_text_field.dart';
import 'package:provider/provider.dart';
import 'package:kid_manager/core/storage_keys.dart';

import '../../core/alert_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final StorageService _storage;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool rememberPassword = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _storage = context.read<StorageService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRememberedLogin();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // LẤY SERVICE Ở ĐÂY (an toàn nhất)
    //_storage = context.read<StorageService>();
  }

  Future<void> _onLoginPressed() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text; // thường không trim password

    // Validate
    if (email.isEmpty || password.isEmpty) {
      AlertService.showSnack('Vui lòng nhập đầy đủ thông tin', isError: true);
      return;
    }

    if (!Validators.isValidEmail(email)) {
      AlertService.showSnack('Email không hợp lệ', isError: true);
      return;
    }

    // Debug
    // debugPrint('====== LOGIN DEBUG ======');
    // debugPrint('📧 Email: $email');
    // debugPrint('🔑 Password: $password');
    // debugPrint('🔑 RememberPassword: $rememberPassword');
    // debugPrint('=========================');

    final authRepo = context.read<AuthRepository>();
    final storage = context.read<StorageService>();

    try {
      final cred = await authRepo.login(email, password);
      final uid = cred.user!.uid;

      await storage.setString(StorageKeys.uid, uid);

      // remember login
      if (rememberPassword) {
        final session = LoginSession(
          email: email,
          uid: cred.user!.uid,
          remember: true,
        );
        final raw = JsonHelper.encode(session.toJson());
        await storage.setString(StorageKeys.login_preference, raw);
      } else {
        await storage.remove(StorageKeys.login_preference);
      }
    } catch (e) {
      AlertService.error(message: 'Đăng nhập thất bại');
    }
  }

  Future<void> _loadRememberedLogin() async {
    final raw = _storage.getString(StorageKeys.login_preference);
    if (raw == null) return;

  try {
    final map = JsonHelper.decode(raw);
    final session = LoginSession.fromJson(map);

    if (!session.remember) return;
    if (!mounted) return; // ✅ check LẦN NỮA trước setState

    setState(() {
      _emailCtrl.text = session.email;
      rememberPassword = true;
    });
  } catch (e) {
    debugPrint('❌ Failed to load login session: $e');
  }
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 216.85,
                      height: 203.40,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/Illustration.svg',
                        width: 203.40,
                        height: 203.40,
                      ),
                    ),

                    const SizedBox(height: 21),
                    SizedBox(
                      width: 266,
                      child: Text(
                        'CHÀO MỪNG TRỞ LẠI',
                        textAlign: TextAlign.center,
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
                        'Đăng nhập ngay!',
                        textAlign: TextAlign.center,
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

                const SizedBox(height: 21),

                AuthTextField(
                  controller: _emailCtrl,
                  hintText: 'Nhập email',
                  keyboardType: TextInputType.emailAddress,
                  prefixSvg: 'assets/icons/user.svg',
                ),
                const SizedBox(height: 1),
                AuthTextField(
                  controller: _passwordCtrl,
                  hintText: 'Nhập mật khẩu',
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  isPassword: true,
                  prefixSvg: 'assets/icons/lock.svg',
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rememberPassword = !rememberPassword;
                          });
                        },
                        behavior:
                            HitTestBehavior.opaque, // 👈 vẫn bấm được cả vùng
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Checkbox
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: rememberPassword
                                    ? const Color(0xFF3A7DFF)
                                    : Colors.transparent,
                                border: Border.all(
                                  width: 2,
                                  color: rememberPassword
                                      ? const Color(0xFF3A7DFF)
                                      : const Color(0xFF49454F),
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: rememberPassword
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
                              'Lưu mật khẩu',
                              style: TextStyle(
                                color: Color(0xFF6C7278),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                letterSpacing: -0.12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(), // 👈 đẩy text phải ra mép
                      // Text phải
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Quên mật khẩu ?',
                          style: TextStyle(
                            color: Color(0xFF3A7DFF),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            letterSpacing: -0.12,
                          ),
                        ),
                      ),
                    ],
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
                        text: 'Đăng nhập',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        onPressed: _onLoginPressed,
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
                      'Bạn chưa có tài khoản, ',
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
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'đăng ký',
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
