import 'package:ez_orgnize/screans/Cheak.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'fire_base/firebase_options.dart';

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
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: cheak(),
    );

  }
}