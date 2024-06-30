import 'dart:async';

import 'package:airsoftplanner/models/user_manager.dart';
import 'package:flutter/material.dart';
import '../models/event_model.dart'; 
import '../database_service.dart'; 
import 'profile_screen.dart';
import '../widgets/event_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Event>>? futureEvents;

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents(); 
  }

  Future<void> fetchUpcomingEvents() async {
    try {
      setState(() {
        futureEvents = DatabaseService().getUpcomingEvents();
      });
    } catch (e) {
      print('Error fetching upcoming events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airsoft Event Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: UserManager.loggedInUser!.id),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 34, 34, 34),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Events",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error occurred: ${snapshot.error}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No events found',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final event = snapshot.data![index];
                        return EventCard(event: event);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
