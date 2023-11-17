import 'package:ez_orgnize/modeals/event_model.dart';
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              eventLeader.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              eventLeader.eventName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${eventLeader.eventLocation}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(eventLeader.eventDate)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${eventLeader.eventTime.toString()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Event Details: ${eventLeader.eventDetails}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Male Organizers: ${eventLeader.maleOrganizers}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Female Organizers: ${eventLeader.femaleOrganizers}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 1),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MembersInTheEvent(event: eventLeader),
                ),
              ),
              child: Text('Members'),
            ),
          ],
        ),
      ),
    );
  }
}
