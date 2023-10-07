import 'package:ez_orgnize/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Myapp());
}

class Myapp extends StatelessWidget{
  const Myapp ({super.key});

  @override
  Widget build(BuildContext context){
    return  MaterialApp(

      debugShowCheckedModeBanner: false,
      home: log_in(),
    );

  }
}