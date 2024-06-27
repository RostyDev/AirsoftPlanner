import 'package:airsoftplanner/models/user_model.dart';
import '../models/user_manager.dart';
import 'package:airsoftplanner/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? loggedInUser = UserManager.loggedInUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Airsoft Event Planner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen(userId: loggedInUser!.id)),
            );
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}