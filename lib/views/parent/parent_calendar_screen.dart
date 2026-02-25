import 'package:flutter/material.dart';

class ParentCalendarScreen extends StatelessWidget {
  const ParentCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Parent Calendar Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
