import 'package:ez_orgnize/screans/home_page.dart';
import 'package:ez_orgnize/screans/login.dart';
import 'package:ez_orgnize/widget/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class cheak extends StatelessWidget{
  const cheak({super.key});
//show  home page or not
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){

              //Show home page
              if (snapshot.hasData){
                return Main();
              }
              //show login page
              else{
                return LogIn(onPressed: () {  },);
                //error
              }
            }
        )
    );
  }//Widget build
}//StatelessWidget
