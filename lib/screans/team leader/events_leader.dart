import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/Models/event_model.dart';
import 'package:ez_orgnize/screans/team%20leader/event_det_leader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsLeader extends StatefulWidget {
  const EventsLeader({
    super.key,
  });

  @override
  State<EventsLeader> createState() => _EventsLeaderState();
}

class _EventsLeaderState extends State<EventsLeader> {
  late List<Event> events;
  bool _isLoading = true;
  Event? selectedEvent;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();

    setState(() {
      events = snapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEvent = events[index];
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EventDetLeader(eventLeader: selectedEvent!),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      events[index].imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      events[index].eventName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${events[index].eventLocation}'),
                        Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(events[index].eventDate)}'),
                        Text('Time: ${events[index].eventTime.toString()}'),
                        // Add more event details as needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
