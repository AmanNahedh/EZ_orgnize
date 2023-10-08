import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class home_page extends StatelessWidget {
  home_page({super.key});
  final user = FirebaseAuth.instance.currentUser;
  void signout(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed:signout,
              icon: Icon(Icons.logout),
          )
        ]
      ),
      body: Center(child: Text('Finally Login In ^_^')),

    );
  }
}
