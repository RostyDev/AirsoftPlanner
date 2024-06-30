import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({required this.event, super.key});

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: const Color.fromARGB(255, 116, 116, 116),
      ),
      body: Container(
        color: const Color.fromARGB(255, 48, 48, 48),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event.beschrijving,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Start Date: ${formatDateTime(event.startdate)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'End Date: ${formatDateTime(event.enddate)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: ${event.location}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
