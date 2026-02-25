import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Parent Dashboard Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
