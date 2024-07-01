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
            return Padding(
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
                    Container(
                      height: MediaQuery.of(context).size.height /
                          3, 
                      child: FutureBuilder<List<Event>?>(
                        future: fetchUserEvents(),
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
                            return const SizedBox(      //als niks is gevonden
                              height: 20,
                            ); 
                          } else {
                            List<Event> userEvents = snapshot.data!;
                            return SingleChildScrollView(
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
                                  ListView.builder(
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
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
