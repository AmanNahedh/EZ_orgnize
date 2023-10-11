import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var firstName = '';
  var secondName = '';
  var image = '';
  var id = FirebaseAuth.instance.currentUser!.uid;
  var emal = FirebaseAuth.instance.currentUser!.email;

  void getUser() async {
    var user =
        await FirebaseFirestore.instance.collection('Users').doc(id).get();
    setState(() {
      firstName = user.data()!['FirstName'];
      secondName = user.data()!['LastName'];
      image = user.data()!['url'];
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 1,
          ),
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
                        child:
                            CircularProgressIndicator(), // Show loading indicator
                      )
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$firstName $secondName',
            style: GoogleFonts.abhayaLibre().copyWith(fontSize: 50),
          ),
          Text(
            '$emal',
            style: GoogleFonts.abhayaLibre().copyWith(fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.teal),
                    top: BorderSide(color: Colors.teal),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('5'),
                      Text(
                        'work houer',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 70,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('5'), Text('rating')],
                  ),
                ),
              ),
              Container(
                height: 70,
                width: 80,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.teal),
                    top: BorderSide(color: Colors.teal),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('5'),
                      Text('events'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Divider(thickness: 2,endIndent: 40,indent: 40, color: Colors.teal[100],),
        ],
      ),
    );
  }
}
