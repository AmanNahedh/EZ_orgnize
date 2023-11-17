import 'package:ez_orgnize/fire_base/Cheak.dart';
import 'package:ez_orgnize/fire_base/firebase_options.dart';
import 'package:ez_orgnize/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getCustomAppTheme(),
      debugShowCheckedModeBanner: false,
      home: cheak(),
    );
  }
}
