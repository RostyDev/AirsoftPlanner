import 'package:airsoftplanner/models/inschrijving_DTO.dart';
import 'package:airsoftplanner/models/user_model.dart';
import 'package:flutter/material.dart';
import '../database_service.dart';
import '../models/event_model.dart';
import '../models/user_manager.dart';
import 'inlog_screen.dart';
import '../widgets/event_card_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userId});

  final int userId;

  Future<List<Event>?> fetchUserEvents() async {
    return await DatabaseService().getUpcomingEventsByUserId(userId);
  }

  Future<List<Event>> fetchInschrijvingEvents() async {
    List<InschrijvingDTO> inschrijvingen =
        await DatabaseService().getInschrijvingenByUserId(userId);
    return inschrijvingen.map((inschrijving) => inschrijving.event!).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnProfile = UserManager.loggedInUser!.id == userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              UserManager.clearUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InlogScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: DatabaseService().getUserProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found'));
          } else {
            User userProfile = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username: ${userProfile.gebruikersnaam}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description: ${userProfile.beschrijving}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 16),
                    if (isOwnProfile)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Events',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              FutureBuilder<List<Event>?>(
                                future: fetchUserEvents(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            'Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No events found'));
                                  } else {
                                    List<Event> userEvents =
                                        snapshot.data!;
                                    return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: userEvents.length,
                                      itemBuilder: (context, index) {
                                        return EventCard(
                                          event: userEvents[index],
                                          onEventDeleted: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text(
                      'Events you are signed up for',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: SingleChildScrollView(
                        child: FutureBuilder<List<Event>>(
                          future: fetchInschrijvingEvents(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No events found'),
                              );
                            } else {
                              List<Event> inschrijvingEvents =
                                  snapshot.data!;
                              return ListView.builder(
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: inschrijvingEvents.length,
                                itemBuilder: (context, index) {
                                  return EventCard(
                                    event: inschrijvingEvents[index],
                                    onEventDeleted: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
