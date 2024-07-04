import 'package:airsoftplanner/database_service.dart';
import 'package:airsoftplanner/models/inschrijving_DTO.dart';
import 'package:airsoftplanner/models/inschrijving_model.dart';
import 'package:airsoftplanner/models/user_manager.dart';
import 'package:airsoftplanner/models/user_model.dart';
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final VoidCallback onEventDeleted;

  const EventDetailScreen({
    required this.onEventDeleted,
    required this.event,
    super.key,
  });

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  InschrijvingDTO? userInschrijving;

  @override
  void initState() {
    super.initState();
    fetchUserInschrijving();
  }

  Future<void> fetchUserInschrijving() async {
    if (UserManager.loggedInUser != null) {
      final inscription = await DatabaseService().getInschrijving(
        widget.event.id,
        UserManager.loggedInUser!.id,
      );
      setState(() {
        userInschrijving = inscription;
      });
    }
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(dateTime);
  }

  Future<void> deleteEvent() async {
    await DatabaseService().deleteEvent(widget.event.id);

    if (mounted) {
      widget.onEventDeleted();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event deleted'),
        ),
      );
      Navigator.pop(context);
      fetchUserInschrijving();
    }
  }

  Future<void> deleteInschrijving() async {
    if (userInschrijving != null) {
      await DatabaseService().deleteInschrijving(userInschrijving!);
      setState(() {
        userInschrijving = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inschrijving verwijderd'),
        ),
      );
    }
  }

  Future<void> updateInschrijvingStatus(int newStatus) async {
    if (userInschrijving != null) {
      userInschrijving!.status = newStatus;

      Inschrijving tijdelijk = Inschrijving(
        event_id: userInschrijving!.event!.id,
        gebruiker_id: userInschrijving!.gebruiker!.id,
        status: userInschrijving!.status,
      );

      await DatabaseService().updateInschrijvingStatus(tijdelijk);

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status bijgewerkt'),
        ),
      );
    }
  }

  void editEvent(BuildContext context) {
    //todo
  }

  Future<void> inschrijvenEvent(Event event, User user, int status) async {
    await DatabaseService().addInschrijving(Inschrijving(
      id: 0,
      event_id: event.id,
      gebruiker_id: user.id,
      status: status,
    ));
    fetchUserInschrijving();
  }

  @override
  Widget build(BuildContext context) {
    bool canModify = UserManager.loggedInUser!.id == widget.event.idGebruiker;
    bool isUserLoggedIn = UserManager.loggedInUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        backgroundColor: const Color.fromARGB(255, 116, 116, 116),
      ),
      body: Container(
        color: const Color.fromARGB(255, 48, 48, 48),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.event.beschrijving,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Start Date: ${formatDateTime(widget.event.startdate)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'End Date: ${formatDateTime(widget.event.enddate)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: ${widget.event.location}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            if (userInschrijving != null)
              Card(
                color: const Color.fromARGB(255, 116, 116, 116),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Je bent ingeschreven voor dit event.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          DropdownButton<int>(
                            value: userInschrijving!.status,
                            dropdownColor:
                                const Color.fromARGB(255, 116, 116, 116),
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('Not Sure'),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Going'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Paid and Going'),
                              ),
                            ],
                            onChanged: (int? newStatus) {
                              if (newStatus != null) {
                                updateInschrijvingStatus(newStatus);
                              }
                            },
                          ),
                          const SizedBox(width: 60),
                          ElevatedButton(
                            onPressed: deleteInschrijving,
                            child: const Text('Uitschrijven'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 116, 116, 116),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (canModify)
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Event'),
                        content: const Text(
                            'Are you sure you want to delete this event?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () async {
                              await deleteEvent();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            if (canModify)
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.blue,
                onPressed: () {
                  editEvent(context);
                },
              ),
            if (!canModify && isUserLoggedIn && userInschrijving == null)
              ElevatedButton(
                onPressed: () async {
                  await inschrijvenEvent(
                      widget.event, UserManager.loggedInUser!, 0);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingeschreven voor het event'),
                    ),
                  );
                },
                child: const Text('Inschrijven'),
              ),
          ],
        ),
      ),
    );
  }
}
