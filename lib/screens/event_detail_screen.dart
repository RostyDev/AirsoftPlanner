import 'package:airsoftplanner/database_service.dart';
import 'package:airsoftplanner/models/user_manager.dart';
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
    }
  }

  void editEvent(BuildContext context) {
    // Navigate to EditEventScreen or implement edit logic here
    // For example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EditEventScreen(event: widget.event),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    bool canModify = UserManager.loggedInUser!.id == widget.event.idGebruiker;

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
          ],
        ),
      ),
    );
  }
}
