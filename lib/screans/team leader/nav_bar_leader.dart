import 'package:ez_orgnize/screans/member/home_page_useer.dart';
import 'package:ez_orgnize/screans/member/profile.dart';
import 'package:ez_orgnize/screans/team%20leader/home_page_leader.dart';
import 'package:flutter/material.dart';

class NavBarLeader extends StatefulWidget {
  const NavBarLeader({super.key});

  @override
  State<NavBarLeader> createState() => _NavBarLeaderState();
}

class _NavBarLeaderState extends State<NavBarLeader> {
  var index = 0;

  final bottom = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
  ];
  final List<Widget> screens = [
    const HomePageLeader(), // Replace with the appropriate widget for your home page
    const HomePageMember(), // Replace with the appropriate widget for the second item
    const Profile(),
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
