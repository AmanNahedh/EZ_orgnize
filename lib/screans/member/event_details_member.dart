import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/Models/event_model.dart';
import 'package:ez_orgnize/Models/usermodeal.dart';
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
  var femaleCounter = 0;
  var maleCounter = 0;
  var applayed = false;

  var isLoading = true;

  void getApplaying() async {
    print(widget.event.eventName);
    setState(() {
      maleCounter = 0;
      male.clear();
      femaleCounter = 0;
      female.clear();
    });

    // Retrieve the existing data from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          male = List<String>.from(data['maleAccept'] ?? []);
          female = List<String>.from(data['femaleAccept'] ?? []);
          maleCounter = male.length;
          femaleCounter = female.length;
          checkApplayed();
        });
      }
    }

    // Simulate a loading delay of 2 seconds
    await Future.delayed(const Duration(milliseconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  Future<UserModel?> getCurrentUserInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        curent = UserModel.fromSnapshot(userData);
      } else {
        print('User document does not exist');
        return curent; // Return the provided currentUser object if the document does not exist
      }
    } catch (e) {
      print('Error retrieving current user info: $e');
      return curent; // Return the provided currentUser object in case of an error
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getApplaying();
    getCurrentUserInfo();
    checkApplayed();
  }

  void checkApplayed() {
    if (male.contains(FirebaseAuth.instance.currentUser!.uid) ||
        female.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        applayed = true;
      });
    }
  }

  void applyToEvent() async {
    getApplaying();

    if (curent!.gender == 'Male') {
      male.add(FirebaseAuth.instance.currentUser!.uid);
      maleCounter = male.length;

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventName)
          .update({'maleAccept': male, 'maleCounter': maleCounter});
    } else {
      female.add(FirebaseAuth.instance.currentUser!.uid);
      femaleCounter = female.length;

      print('female added');
      print('immmmmmheeeeeeeerrrreeee');
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventName)
          .update({'femaleAccept': female, 'femaleCounter': femaleCounter});
    }
    checkApplayed();
  }

  void unApplyToEvent() async {
    getApplaying();
    if (curent!.gender == 'Male') {
      male.remove(FirebaseAuth.instance.currentUser!.uid);
      maleCounter - male.length;

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventName)
          .update({'maleAccept': male, 'maleCounter': maleCounter});
      applayed = false;
    } else {
      female.remove(FirebaseAuth.instance.currentUser!.uid);
      femaleCounter = female.length;
      applayed = false;

      print('female removed');
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventName)
          .update({'femaleAccept': female, 'femaleCounter': femaleCounter});
    }
    checkApplayed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.eventName),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.event.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.event.eventName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${widget.event.eventLocation}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(widget.event.eventDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time: ${widget.event.eventTime.toString()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Event Details: ${widget.event.eventDetails}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Male Organizers: ${widget.event.maleOrganizers}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Female Organizers: ${widget.event.femaleOrganizers}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  applayed
                      ? ElevatedButton(
                          onPressed: unApplyToEvent,
                          child: const Text('UnApply'),
                        )
                      : ElevatedButton(
                          onPressed: applyToEvent,
                          child: const Text('Apply'),
                        ),
                ],
              ),
            ),
    );
  }
}
