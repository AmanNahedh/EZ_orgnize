import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/fire_base/Cheak.dart';
import 'package:ez_orgnize/screans/member/event_member.dart';
import 'package:ez_orgnize/utils/onesignal_manager.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageMember extends StatefulWidget {
  HomePageMember({Key? key});

  @override
  State<HomePageMember> createState() => _HomePageMemberState();
}

class _HomePageMemberState extends State<HomePageMember> {
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

   Future<void> signOut() async{
     await OneSignalManager.clearNotification();
    await OneSignalManager.removeExternalUserId();
    FirebaseAuth.instance.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => cheak(),
      ),
    );
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text('events'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventMember(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
