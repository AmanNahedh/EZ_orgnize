import 'package:flutter/material.dart';

class Text_Filled extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;
  const Text_Filled ({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller:controller ,
        obscureText:obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText:hintText,
        ),
      ),
    );
  }
}
