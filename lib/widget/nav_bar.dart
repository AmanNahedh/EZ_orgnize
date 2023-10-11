import 'package:ez_orgnize/screans/home_page.dart';
import 'package:ez_orgnize/screans/profile.dart';
import 'package:flutter/material.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {



  var index = 0;

  final bottom = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
  ];
  final List<Widget> screens = [
    home_page(), // Replace with the appropriate widget for your home page
    home_page(), // Replace with the appropriate widget for the second item
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
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
