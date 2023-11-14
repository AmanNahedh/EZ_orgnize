import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final String eventLocation;
  final String eventDetails;
  final int maleOrganizers;
  final int femaleOrganizers;
  final String imageUrl;

  Event({
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventDetails,
    required this.maleOrganizers,
    required this.femaleOrganizers,
    required this.imageUrl,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventName: map['eventName'],
      eventDate: map['eventDate'].toDate(),
      eventTime: map['eventTime'],
      eventLocation: map['eventLocation'],
      eventDetails: map['eventDetails'],
      maleOrganizers: map['maleOrganizers'],
      femaleOrganizers: map['femaleOrganizers'],
      imageUrl: map['imageUrl'],
    );
  }

  Future<void> createApllayingDocument(male, female) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventName)
        .collection('Apllaying')
        .doc('Apllaying')
        .set({
      'male': male,
      'female': female,
    });
  }
}
