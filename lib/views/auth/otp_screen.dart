import 'package:flutter/material.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:kid_manager/widgets/common/loading_view.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;

  void _verifyOtp() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // giả lập API

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 169,
                    child: Text(
                      'NHẬP MÃ OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: 250,
                    height: 45,
                    child: Text(
                      'Chúng tôi đã gửi mã xác minh đến địa chỉ email của bạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4A4A4A),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _OtpInputBox(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          nextFocus: i < 3 ? _focusNodes[i + 1] : null,
                          prevFocus: i > 0 ? _focusNodes[i - 1] : null,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Gửi lại mã',
                      style: TextStyle(
                        color: Color(0xFF3A7DFF),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        letterSpacing: -0.12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  AppButton(
                    text: 'Xác minh',
                    width: 150,
                    height: 50,
                    onPressed: () {
                      setState(() => _isLoading = true);

                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => _isLoading = false);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // 👇 Overlay loading
          if (_isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}

class _OtpInputBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? prevFocus;

  const _OtpInputBox({
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.prevFocus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 59,
      height: 59,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          color: Color(0xFF757575),
        ),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: _border(false),
          focusedBorder: _border(true),
          contentPadding: const EdgeInsets.only(bottom: 20),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            nextFocus?.requestFocus();
          } else {
            prevFocus?.requestFocus();
          }
        },
      ),
    );
  }

  OutlineInputBorder _border(bool active) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        width: 1.6,
        color: active ? const Color(0xFF3A7DFF) : const Color(0xFFDDDDDD),
      ),
    );
  }
}
