import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  Attendance({Key? key, required this.id, required this.event})
      : super(key: key);
  final String id;
  final Event event;

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool isAttendanceSigned = false;
  UserModel? member;

  String startTime = '';
  String endTime = '';
  String lateTime = '';

  late DateTime startTimeTime;

  late DateTime endTimeTime;

  late DateTime lateTimeTime;

  void fetchTimes() async {
    var value = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc('${widget.id}')
        .get();
    setState(() {
      startTime = value.data()!['start time'] ?? '';
      print('test');
      endTime = value.data()!['end time'] ?? '';
      lateTime = value.data()!['Late time'] ?? '';
    });
  }

  void signAttendance() {}

  void absent() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc('${widget.id}')
        .update({
      "end Time": '',
      'start time': '',
      'Late time': '',
      'attend': false,
    });
  }

  Future<void> startShift() async {
    // Show a dialog to choose whether to sign the time now or pick it manually
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Start Time'),
          content: Text(
              'Do you want to sign the start time now or pick it manually?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Sign the start time as the current time
                startTimeTime = DateTime.now();
                startTime = startTimeTime.toString();
                print('Shift started at: $startTime');
                saveAttendance();
              },
              child: Text('Now'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Pick the start time manually
                await pickStartTime();
                print('Shift started at: $startTime');
                saveAttendance();
              },
              child: Text('Manually'),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickStartTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      startTimeTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );
      startTime = startTimeTime.toString();
    }
  }

  Future<void> saveAttendance() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc('${widget.id}')
        .set({
      "gender": member!.firstName,
      "FirstName": member!.firstName,
      "LastName": member!.lastName,
      "PhoneNumber": member!.phoneNumber,
      "Nationality": member!.nationality,
      "Validity": member!.validity,
      "tallCont": member!.tallCont,
      "weightCont": member!.weightCont,
      "id": widget.id,
      "start time": startTimeTime.toString(),
      "attend": true
    });

    print('Attendance saved');
  }

  Future<void> endShift() async {
    // Show a dialog to choose whether to sign the time now or pick it manually
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose End Time'),
          content:
              Text('Do you want to sign the end time now or pick it manually?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Sign the end time as the current time
                endTimeTime = DateTime.now();
                endTime = endTimeTime.toString();
                print('Shift ended at: $endTime');
                setState(() {
                  saveAttendanceend();
                });
              },
              child: Text('Now'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Pick the end time manually
                await pickEndTime();
                print('Shift ended at: $endTime');
                saveAttendanceend();
                endTime = endTimeTime.toString();
              },
              child: Text('Manually'),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickEndTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      endTimeTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );
      endTime = endTimeTime.toString();
    }
  }

  Future<void> saveAttendanceend() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc('${widget.id}')
        .update({"end time": endTimeTime.toString()});

    print('Attendance updated');
  }

  Future<void> pickLateTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      lateTimeTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        lateTime = lateTimeTime.toString();
      });

      // Save the late time to the database or perform other actions

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventName)
          .collection('attend')
          .doc('${widget.id}')
          .update({"Late time": lateTimeTime.toString()});
    }
  }

  Future<void> delay() async {
    await Future.delayed(Duration(seconds: 2));
    // Perform your action here
  }

  @override
  void initState() {
    fetchTimes();
    delay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rating = 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('attend'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('Users').doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred while fetching user data'),
            );
          }

          final user = UserModel.fromSnapshot(
              snapshot.data!.data() as Map<String, dynamic>);
          final firstName = user.firstName ?? '';
          final lastName = user.lastName ?? '';
          final image = user.image ?? '';

          member = user;

          return Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: image.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$firstName $lastName',
                style: GoogleFonts.abhayaLibre().copyWith(fontSize: 50),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SpotCard(
                    time: startTime,
                    fun: startShift,
                    mainTitle: 'start shift',
                  ),
                  SpotCard(
                    time: endTime,
                    fun: endShift,
                    mainTitle: 'end shift',
                  ),
                  SpotCard(
                    time: lateTime,
                    fun: pickLateTime,
                    mainTitle: 'late',
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: absent, child: Text('absent')),
              RatingBar.builder(
                initialRating: rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                  print(rating);
                  // Perform any actions based on the new rating
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class SpotCard extends StatefulWidget {
  late String time;
  final String mainTitle;
  final Function() fun;

  SpotCard(
      {Key? key,
      required this.fun,
      required this.mainTitle,
      required this.time})
      : super(key: key);

  @override
  State<SpotCard> createState() => _SpotCardState();
}

class _SpotCardState extends State<SpotCard> {
  Widget date() {
    setState(() {
      DateTime dateTime = DateTime.parse(widget.time);
      widget.time = DateFormat('hh:mm a').format(dateTime);
    });
    return Text(widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 120,
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.time == '' ? Text('') : date(),
              ElevatedButton(
                onPressed: () async {
                  widget.fun();
                },
                child: Text(
                  widget.mainTitle,
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
