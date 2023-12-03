import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key, required this.id, required this.event})
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

  var time = 0.0;
  var preformance = 0.0;
  var behavior = 0.0;

  void submit() async {
    Duration timeDifference;
    var memberTime;
    var rating = (time + preformance + behavior) / 3;
    var memberRating;
    double finalRate;
    fetchTimes();
    if (startTime == '' && endTime == '') {
      return;
    } else if (startTime == '') {
      timeDifference = endTimeTime.difference(lateTimeTime);
    } else {
      timeDifference = endTimeTime.difference(startTimeTime);
    }
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc(widget.id)
        .update({
      'respect the time': time,
      'Performance at work': preformance,
      'Good behavior': behavior,
      'timeDifference': timeDifference.inHours.toString(),
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.id)
        .get()
        .then((value) {
      memberTime = value.data()!['work time'];

      memberRating = value.data()!['rating'];
    });

    print('rate fetch');
    finalRate = (memberRating + rating) / 2;
    await FirebaseFirestore.instance.collection('Users').doc(widget.id).update({
      'work time': memberTime + timeDifference.inHours,
      'rating': finalRate
    });
    print('done');
    fetchStars();
  }

  late DateTime startTimeTime = DateTime.now();

  late DateTime endTimeTime = DateTime.now();

  late DateTime lateTimeTime = DateTime.now();

  void fetchTimes() async {
    var value = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc(widget.id)
        .get();
    setState(() {
      startTime = value.data()!['start time'] ?? '';
      print('test');
      endTime = value.data()!['end time'] ?? '';
      lateTime = value.data()!['late time'] ?? '';
    });
    fetchStars();
  }

  void fetchStars() async {
    var value = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc(widget.id)
        .get();
    setState(() {
      time = value.data()!['respect the time'] ?? '';
      preformance = value.data()!['Performance at work'] ?? '';
      behavior = value.data()!['Good behavior'] ?? '';
    });
  }

  void signAttendance() {}

  void absent() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc(widget.id)
        .update({
      "end time": '',
      'start time': '',
      'late time': '',
      'attend': false,
    });
    setState(() {
      fetchTimes();
    });
  }

  Future<void> startShift() async {
    // Show a dialog to choose whether to sign the time now or pick it manually
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Start Time'),
          content: const Text(
              'Do you want to sign the start time now or pick it manually?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Sign the start time as the current time
                startTimeTime = DateTime.now();
                startTime = startTimeTime.toString();
                print('Shift started at: $startTime');
                setState(() {
                  saveAttendance();
                });
              },
              child: const Text('Now'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Pick the start time manually
                await pickStartTime();
                print('Shift started at: $startTime');
                saveAttendance();
              },
              child: const Text('Manually'),
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
      setState(() {
        startTime = startTimeTime.toString();
      });
    }
  }

  Future<void> saveAttendance() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc(widget.id)
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
          title: const Text('Choose End Time'),
          content: const Text(
              'Do you want to sign the end time now or pick it manually?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Sign the end time as the current time
                endTimeTime = DateTime.now();
                endTime = endTimeTime.toString();
                setState(() {
                  saveAttendanceend();
                });
              },
              child: const Text('Now'),
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
              child: const Text('Manually'),
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
      setState(() {
        endTime = endTimeTime.toString();
      });
    }
  }

  Future<void> saveAttendanceend() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .collection('attend')
        .doc(widget.id)
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
        startTime = '';
        lateTime = lateTimeTime.toString();
      });

      // Save the late time to the database or perform other actions

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventName)
          .collection('attend')
          .doc(widget.id)
          .update({"Late time": lateTimeTime.toString()});
    }
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 2));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('attend'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('Users').doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
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
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: image.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$firstName $lastName',
                style: GoogleFonts.abhayaLibre().copyWith(fontSize: 50),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 10),
              ElevatedButton(onPressed: absent, child: const Text('absent')),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'respect the time',
                    style: TextStyle(fontSize: 20),
                  ),
                  RatingBar.builder(
                    itemSize: 32,
                    initialRating: time,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      time = newRating;

                      // Perform any actions based on the new rating
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Performance at work',
                    style: TextStyle(fontSize: 20),
                  ),
                  RatingBar.builder(
                    itemSize: 32,
                    initialRating: preformance,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      preformance = newRating;

                      // Perform any actions based on the new rating
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Good behavior',
                    style: TextStyle(fontSize: 20),
                  ),
                  RatingBar.builder(
                    itemSize: 32,
                    initialRating: behavior,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      behavior = newRating;

                      // Perform any actions based on the new rating
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: submit, child: const Text('Submit')),
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
      child: SizedBox(
        width: 120,
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.time == '' ? const Text('') : date(),
              ElevatedButton(
                onPressed: () async {
                  widget.fun();
                },
                child: Text(
                  widget.mainTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
