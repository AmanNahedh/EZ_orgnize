import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/screans/admin/nav_bar_admin.dart';
import 'package:ez_orgnize/screans/login.dart';
import 'package:ez_orgnize/screans/team%20leader/nav_bar_leader.dart';
import 'package:ez_orgnize/widget/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class cheak extends StatefulWidget {
  const cheak({super.key});

  @override
  State<cheak> createState() => _cheakState();
}

var Validity;

class _cheakState extends State<cheak> {
  void checkValidity() async {
    var user = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      Validity = user.data()!['Validity'];
    });
  }

  @override
  void initState() {
    checkValidity();
    super.initState();
  }

//show home page or not
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //Show home page
          if (snapshot.hasData) {
            if (Validity == 'admin') {
              return NavBarAdmin();
            } else if (Validity == 'TeamLeader') {
              return NavBarLeader();
            } else
              return NavBarMember();
          }
          //show login page
          else {
            return LogIn(
              onPressed: () {},
            );
            //error
          }
        },
      ),
    );
  }
} //StatelessWidget
