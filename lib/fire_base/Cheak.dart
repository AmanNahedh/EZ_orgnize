import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/screans/admin/nav_bar_admin.dart';
import 'package:ez_orgnize/screans/login.dart';
import 'package:ez_orgnize/screans/team%20leader/nav_bar_leader.dart';
import 'package:ez_orgnize/utils/onesignal_manager.dart';
import 'package:ez_orgnize/widget/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class cheak extends StatefulWidget {
  const cheak({super.key});

  @override
  State<cheak> createState() => _cheakState();
}

var Validity;

class _cheakState extends State<cheak> {
  Future<void> checkValidity() async {
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
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await checkValidity();
    await OneSignalManager.initialize();
    _handleNotification();
  }

  Future<void> _handleNotification() async {
    final bool permission =
        await OneSignal.shared.promptUserForPushNotificationPermission();
    if (!permission) {
      print("Need notification permission access");
    }
    OneSignalManager.handleNotifications(
      onForeground: (notif) {
        print("New notification in foreground");

        //If you want to hide notification in foreground uncomment:
        //return notif.complete(null);

        return notif.complete(notif.notification);
      },
      onBackgroundOpened: (notif) {
        print("New notification in background");
      },
    );
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
              return const NavBarAdmin();
            } else if (Validity == 'TeamLeader') {
              return const NavBarLeader();
            } else
              return const NavBarMember();
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
