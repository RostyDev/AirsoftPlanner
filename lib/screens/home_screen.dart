import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airsoft Event Planner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add navigation logic here
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}