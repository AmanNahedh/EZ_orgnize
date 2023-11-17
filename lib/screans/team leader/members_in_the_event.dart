import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:ez_orgnize/screans/team%20leader/member_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MembersInTheEvent extends StatefulWidget {
  const MembersInTheEvent({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  _MembersInTheEventState createState() => _MembersInTheEventState();
}

class _MembersInTheEventState extends State<MembersInTheEvent> {
  var id = FirebaseAuth.instance.currentUser!.uid;
  late List<UserModel> acceptedMembers = [];
  late List<String> startTime =
      List.generate(acceptedMembers.length, (index) => '');
  late List<String> endTime =
      List.generate(acceptedMembers.length, (index) => '');
  late List<String> lateTime =
      List.generate(acceptedMembers.length, (index) => '');

  late List<bool> isShiftStarted =
      List.generate(acceptedMembers.length, (index) => false);
  late List<bool> isShiftEndTime =
      List.generate(acceptedMembers.length, (index) => false);
  late List<bool> isShiftLateTime =
      List.generate(acceptedMembers.length, (index) => false);

  late List<DateTime?> startTimeTime = List.generate(
    acceptedMembers.length,
    (index) {
      DateTime.now();
    },
  );
  late List<DateTime?> endTimeTime = List.generate(
    acceptedMembers.length,
    (index) {
      DateTime.now();
    },
  );
  late List<DateTime?> lateTimeTime = List.generate(
    acceptedMembers.length,
    (index) {
      DateTime.now();
    },
  );

  Future<List<UserModel>> fetchAcceptedMembers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        final List<dynamic>? membersList = data['Accepted Members'];
        if (membersList != null && membersList is List<dynamic>) {
          acceptedMembers.clear();
          for (final memberId in membersList) {
            final memberSnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .doc(memberId)
                .get();

            if (memberSnapshot.exists) {
              final memberData = memberSnapshot.data();
              if (memberData != null && memberData is Map<String, dynamic>) {
                final UserModel member = UserModel.fromSnapshot(memberData);
                acceptedMembers.add(member);
              }
            }
          }
        }
      }
    }

    return acceptedMembers;
  }

  void startShift(UserModel member, index) async {
    setState(() {
      isShiftStarted[index] = true;
    });
    startTime![index] = DateTime.now().toString();
    startTimeTime![index] = DateTime.now();
    print('Shift started at: $startTime');
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc('${member.id}')
        .set({
      "gender": member.gender,
      "FirstName": member.firstName,
      "LastName": member.lastName,
      "PhoneNumber": member.phoneNumber,
      "Nationality": member.nationality,
      "Validity": member.validity,
      "tallCont": member.tallCont,
      "weightCont": member.weightCont,
      "id": member.id,
      "start time": startTimeTime![index].toString()
    });

    print('done');
  }

  void endShift(UserModel member, index) async {
    setState(() {
      isShiftEndTime[index] = true;
    });
    endTime![index] = DateTime.now().toString();
    endTimeTime![index] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc('${member.id}')
        .update({"end Time": endTimeTime![index].toString()});

    print('done');

    print('Shift ended at: $endTime');
    // Perform other actions for shift end
  }

  Future<void> pickLateTime(UserModel member, index) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      lateTime![index] = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      ).toString();
      lateTimeTime![index] = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );
      // Save the late time to the database or perform other actions
      setState(() {
        isShiftLateTime[index] = true;
      });

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventName)
          .collection('attend')
          .doc('${member.id}')
          .update({"end Time": endTimeTime[index].toString()});

      print('Late time: $lateTime');
    }
  }

  void clear(member, index) async {
    setState(() {
      startTime[index] = '';
      endTime[index] = '';
      lateTime[index] = '';

      isShiftStarted[index] = false;
      isShiftEndTime[index] = false;
      isShiftLateTime[index] = false;
    });

    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc('${member.id}')
        .update({"Late time:": null});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Members'),
            Text('${widget.event.eventName} event'),
          ],
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: fetchAcceptedMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text('No members found'),
            );
          } else {
            return SingleChildScrollView(
              // Wrap with SingleChildScrollView
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: acceptedMembers.length,
                    itemBuilder: (context, index) {
                      final member = acceptedMembers[index];
                      return Container(
                        height: 100,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MemberProfile(
                                      id: member.id,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${member.firstName} ${member.lastName}'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(member.gender ?? ''),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(member.phoneNumber ?? ''),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      isShiftStarted[index]
                                          ? Text((DateFormat('hh:mm a')
                                              .format(startTimeTime![index]!)))
                                          : ElevatedButton(
                                              onPressed: () {
                                                isShiftStarted[index]
                                                    ? null
                                                    : startShift(member, index);
                                              },
                                              child: Text('Start Shift'),
                                            ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      isShiftEndTime[index]
                                          ? Text((DateFormat('hh:mm a')
                                              .format(endTimeTime![index]!)))
                                          : ElevatedButton(
                                              onPressed: () {
                                                isShiftEndTime[index]
                                                    ? null
                                                    : endShift(member, index);
                                              },
                                              child: Text('End Shift'),
                                            ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      isShiftLateTime[index]
                                          ? Text((DateFormat('hh:mm a').format(
                                              lateTimeTime![index]
                                                  as DateTime)))
                                          : ElevatedButton(
                                              onPressed: isShiftLateTime[index]
                                                  ? null
                                                  : () => pickLateTime(
                                                      member, index),
                                              child: Text('Late'),
                                            ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      ElevatedButton(
                                        onPressed: () => clear(member, index),
                                        child: Text('clear'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
