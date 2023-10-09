import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final user = FirebaseAuth.instance.currentUser;
  var index =0;


  void signout() {
    FirebaseAuth.instance.signOut();
  }

  final bottom = [
    BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home'),
    BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home'),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottom,
        currentIndex: index,
        onTap: (value) => setState(() {
          index = value;
        }),
      ),
    );
  }
}
