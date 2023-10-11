import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/screans/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  home_page({Key? key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  var firstName = '';
  var secondName = '';
  var image = '';
  var id = FirebaseAuth.instance.currentUser!.uid;

  void getUser() async {
    var user =
        await FirebaseFirestore.instance.collection('Users').doc(id).get();
    setState(() {
      firstName = user.data()!['FirstName'];
      secondName = user.data()!['LastName'];
      image = user.data()!['url'];
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  void signOut() {
    FirebaseAuth.instance.signOut();
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
        leading: Row(
          children: [
            Container(
              width: 50,
              height: 50,
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
            SizedBox(
              width: 10,
            ),
            Text('$firstName $secondName'),
          ],
        ),
        leadingWidth: MediaQuery.of(context).size.width / 2,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Placeholder(),
    );
  }
}
