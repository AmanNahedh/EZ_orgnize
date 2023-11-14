import 'package:ez_orgnize/screans/home_page_useer.dart';
import 'package:ez_orgnize/screans/profile.dart';
import 'package:flutter/material.dart';

class NavBarMember extends StatefulWidget {
  const NavBarMember({super.key});

  @override
  State<NavBarMember> createState() => _NavBarMemberState();
}

class _NavBarMemberState extends State<NavBarMember> {



  var index = 0;

  final bottom = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
  ];
  final List<Widget> screens = [
    HomePageMember(), // Replace with the appropriate widget for your home page
    HomePageMember(), // Replace with the appropriate widget for the second item
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
