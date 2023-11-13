import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              event.eventName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${event.eventLocation}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(event.eventDate)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${event.eventTime.toString()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Event Details: ${event.eventDetails}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Male Organizers: ${event.maleOrganizers}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Female Organizers: ${event.femaleOrganizers}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle button click event
              },
              child: Text('RSVP'),
            ),
          ],
        ),
      ),
    );
  }
}
