import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsMember extends StatefulWidget {
  final Event event;

  const EventDetailsMember({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailsMember> createState() => _EventDetailsMemberState();
}

class _EventDetailsMemberState extends State<EventDetailsMember> {
  List<String> male = [];
  List<String> female = [];
  UserModel? curent;

  void getApplaying() async {
    setState(() {
      male.clear();
    });
    // Retrieve the existing data from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc('male female')
        .collection('Apllaying')
        .doc('Apllaying')
        .get();

    if (snapshot.exists) {
      setState(() {
        male = List<String>.from(snapshot.get('male'));
      });
    }

    print(male.length);
  }

  void getCurentUSer() {
    UserModel info = UserModel();
    info.getCurrentUserInfo();
    setState(() {
      curent = info;
    });
  }

// Rest of the code...

  @override
  void initState() {
    super.initState();
    getApplaying(); // Add this line to retrieve the current user
    getCurentUSer();
  }

  void applyToEvent() async {
    setState(() {
      male.add(FirebaseAuth.instance.currentUser!.uid);
    });
    print('add done');
    print(male);
    await FirebaseFirestore.instance
        .collection('events')
        .doc('male female')
        .collection('Apllaying')
        .doc('Apllaying')
        .set({'male': male});
    getApplaying();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.eventName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.event.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              widget.event.eventName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${widget.event.eventLocation}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(widget.event.eventDate)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${widget.event.eventTime.toString()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Event Details: ${widget.event.eventDetails}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Male Organizers: ${widget.event.maleOrganizers}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Female Organizers: ${widget.event.femaleOrganizers}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: applyToEvent,
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
