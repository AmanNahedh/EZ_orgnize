import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../General/Text_Filled.dart';


class Forget_pass extends StatefulWidget {
  final Function()? onPressed;
  const Forget_pass({super.key,required this.onPressed});

  @override
  State<Forget_pass> createState() => _Forget_passState();
}
//8
class _Forget_passState extends State<Forget_pass> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  Future PasswordReset() async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog
        (context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Password reset link sent , Cheack Your mail Box"),
          );
        },
      );
    }on FirebaseAuthException catch(c){
      print(c);
      showDialog
        (context: context,
          builder: (context) {
          return AlertDialog(
          content: Text(c.message.toString()),
        );
      },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.teal,
        elevation: 0,

      ),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal:20.0),
          child: Text("Enter Your Email ,and We will send you reset link",
          textAlign: TextAlign.center,
          ),
        ),
          const SizedBox(
            height: 25,
          ),
        Text_Filled(
          controller: emailController,
          hintText: 'Please Enter Email',
          obscureText: false,
        ),
        const SizedBox(
          height: 25,
        ),
          //button(
            //text: "Sign In",
          //  onPressed: Forget_pass,
          //),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: PasswordReset,
            child: const Text('Reset Password'),
          ),


      ],
      
      )
    );
    
  }
}
