import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Về ứng dụng'),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'My Application',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Phiên bản: 1.0.0'),
              SizedBox(height: 16),
              Text(
                'Ứng dụng giúp quản lý tài khoản, '
                'theo dõi hoạt động và cá nhân hóa trải nghiệm người dùng.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text('© 2026 My Company'),
            ],
          ),
        ),
      ),
    );
  }
}