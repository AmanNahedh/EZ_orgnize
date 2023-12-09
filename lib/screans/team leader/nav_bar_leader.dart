import 'package:ez_orgnize/screans/admin_team_pofile.dart';
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
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
  ];
  final List<Widget> screens = [
    const HomePageLeader(),
    const AdminTeamProfile(),
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
