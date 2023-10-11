import 'package:flutter/material.dart';

import '../General/Text_Filled.dart';
import '../General/buttons.dart';


class Forget_pass extends StatefulWidget {
  const Forget_pass({super.key});

  @override
  State<Forget_pass> createState() => _Forget_passState();
}

class _Forget_passState extends State<Forget_pass> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.black,
        elevation: 0,

      ),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Text("Enter Your Email ,and We will send you reset link",
          textAlign: TextAlign.center,
          ),
        ),
          SizedBox(
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
      button(
        onTap: () {
          Text("Forget Pass");
        },
      ),


      ],
      
      )
    );
    
  }
}
