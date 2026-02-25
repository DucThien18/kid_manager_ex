import 'package:flutter/material.dart';

class ChildNotificationScreen extends StatelessWidget {
  const ChildNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Children Notification Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
