import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/fire_base/Cheak.dart';
import 'package:ez_orgnize/utils/onesignal_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  DateTime selectedDate = DateTime.now();
  final _eventNameController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _eventDetailsController = TextEditingController();
  final _maleOrganizersController = TextEditingController();
  final _femaleOrganizersController = TextEditingController();
  var selectedImage;
  bool editMode = false;
  String editModeImageURL = '';
  bool isUploading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventLocationController.dispose();
    _eventDetailsController.dispose();
    _maleOrganizersController.dispose();
    _femaleOrganizersController.dispose();
    super.dispose();
  }

  Future<void> _addEventToFirestore() async {
    final eventName = _eventNameController.text;
    final eventLocation = _eventLocationController.text;
    final eventDetails = _eventDetailsController.text;
    final maleOrganizers = int.parse(_maleOrganizersController.text);
    final femaleOrganizers = int.parse(_femaleOrganizersController.text);

    setState(() {
      isUploading = true;
    });

    try {
      // Upload the image to Firebase Storage
      String imageUrl = '';
      if (selectedImage != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('images/events/$eventName');
        await storageRef.putFile(selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('events').doc(eventName).set({
        'eventName': eventName,
        'eventDate': selectedDate,
        'eventTime': selectedTime?.format(context),
        'eventLocation': eventLocation,
        'eventDetails': eventDetails,
        'maleOrganizers': maleOrganizers,
        'femaleOrganizers': femaleOrganizers,
        'maleCounter': 0,
        'maleAccept': [],
        'femaleCounter': 0,
        'femaleAccept': [],
        'imageUrl': imageUrl,
      });

      // Reset the form after successful submission
      _eventNameController.clear();
      _eventLocationController.clear();
      _eventDetailsController.clear();
      _maleOrganizersController.clear();
      _femaleOrganizersController.clear();

      final result = await FirebaseFirestore.instance
          .collection("Users")
          .where("Validity", isEqualTo: "organizer")
          .get();

      final List<String> usersIds = [];

      for (var element in result.docs) {
        usersIds.add(element.id);
      }

      OneSignalManager.sendNotificationToUsers(
        title: "New event",
        content: "Check the app for the new events",
        targets: usersIds,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Event added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => cheak(),
                  ));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add event. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _eventNameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 8.0),
                        Text(
                          'Event Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        SizedBox(width: 8.0),
                        Text(
                          'Selected Time: ${selectedTime?.format(context) ?? 'Not selected'}',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _eventLocationController,
                  decoration: InputDecoration(
                    labelText: 'Event Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _eventDetailsController,
                  decoration: InputDecoration(
                    labelText: 'Event Details',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'How many organizers do you need?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.teal,
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _maleOrganizersController,
                        decoration: InputDecoration(
                          labelText: 'Male',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: _femaleOrganizersController,
                        decoration: InputDecoration(
                          labelText: 'Female',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Visibility(
                  visible: editMode,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            image: NetworkImage(editModeImageURL))),
                  ),
                  replacement: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child: selectedImage != null
                        ? Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                selectedImage as File,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            // margin: EdgeInsets.symmetric(horizontal: 50),
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.teal,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                Icon(Icons.account_box, size: 50.0),
                                Text(
                                  'Upload your photo',
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: isUploading ? null : _addEventToFirestore,
                  child: isUploading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Add Event',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 95,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.camera,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  label: Text(
                    "Camera",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                Spacer(),
                TextButton.icon(
                  icon: Icon(Icons.image,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  label: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ])
        ],
      ),
    );
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.platform
        .getImageFromSource(source: source); //pickImage
    print('printing source of image $source');
    setState(() {
      selectedImage = File(image!.path);
    });
  }
}
