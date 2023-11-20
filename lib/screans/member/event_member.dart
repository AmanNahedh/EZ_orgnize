import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:ez_orgnize/screans/member/event_details_member.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventMember extends StatefulWidget {
  const EventMember({Key? key});

  @override
  State<EventMember> createState() => _EventMemberState();
}

class _EventMemberState extends State<EventMember> {
  late List<Event> events = [];
  bool _isLoading = true;
  Event? selectedEvent;
  List<Event> male = [];
  List<Event> female = [];
  UserModel curent = UserModel();

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
        print('Inside getCurrentUserInfo');
        print(curent.id);
      } else {
        print('User document does not exist');
        return curent; // Return the provided currentUser object if the document does not exist
      }
    } catch (e) {
      print('Error retrieving current user info: $e');
      return curent; // Return the provided currentUser object in case of an error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    print('am hereeeeee');
    final serverEvents = snapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    final today = DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day);
    for (var element in serverEvents) {
      final DateTime eventDate = DateTime(element.eventDate.year,element.eventDate.month,element.eventDate.day);

      if (eventDate.millisecondsSinceEpoch >= today.millisecondsSinceEpoch) {
        print(element.eventDate);
        events.add(element);
      }
    }
    setState(() {
      getCurrentUserInfo();
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
          : FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('events').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // events = snapshot.data!.docs
                  //     .map((doc) =>
                  //         Event.fromMap(doc.data() as Map<String, dynamic>))
                  //     .toList();
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      Event event = events[index];
                      if ((event.femaleOrganizers == 0 &&
                              curent.gender == 'Female') ||
                          (event.maleOrganizers == 0 &&
                              curent.gender == 'Male')) {
                        return Text('');
                      } else if ((event.maleOrganizers <= event.maleCounter &&
                          event.femaleOrganizers <= event.femaleCounter)) {
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: Colors.grey,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Image.network(
                                events[index].imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                events[index].eventName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text(
                                  'We apologize, we are limited to the number'),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            print(event.femaleOrganizers.toString());

                            setState(() {
                              selectedEvent = events[index];
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailsMember(event: selectedEvent!),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Image.network(
                                events[index].imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                events[index].eventName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Location: ${events[index].eventLocation}'),
                                  Text(
                                    'Date: ${DateFormat('yyyy-MM-dd').format(events[index].eventDate)}',
                                  ),
                                  Text(
                                      'Time: ${events[index].eventTime.toString()}'),
                                  // Add more event details as needed
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
