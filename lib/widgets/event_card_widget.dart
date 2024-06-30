import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({required this.event, super.key});

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              event.beschrijving,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date: ${formatDateTime(event.startdate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'End Date: ${formatDateTime(event.enddate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    event.location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400], // Light grey text color
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
