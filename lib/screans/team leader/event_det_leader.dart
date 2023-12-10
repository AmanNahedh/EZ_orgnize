import 'package:ez_orgnize/Models/event_model.dart';
import 'package:ez_orgnize/screans/team%20leader/members_in_the_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetLeader extends StatelessWidget {
  final Event eventLeader;

  const EventDetLeader({Key? key, required this.eventLeader}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventLeader.eventName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              eventLeader.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              eventLeader.eventName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${eventLeader.eventLocation}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(eventLeader.eventDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${eventLeader.eventTime.toString()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Event Details: ${eventLeader.eventDetails}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Male Organizers: ${eventLeader.maleOrganizers}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Female Organizers: ${eventLeader.femaleOrganizers}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 1),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MembersInTheEvent(event: eventLeader),
                ),
              ),
              child: const Text('Members'),
            ),
          ],
        ),
      ),
    );
  }
}
