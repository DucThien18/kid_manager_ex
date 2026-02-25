import 'package:flutter/material.dart';

class ParentChatScreen extends StatelessWidget {
  const ParentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Parent Chat Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
