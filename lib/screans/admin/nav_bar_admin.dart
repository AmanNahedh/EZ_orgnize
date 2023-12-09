import 'package:ez_orgnize/screans/admin/home_page_admin.dart';
import 'package:ez_orgnize/screans/admin_team_pofile.dart';
import 'package:ez_orgnize/screans/member/home_page_useer.dart';
import 'package:ez_orgnize/screans/member/profile.dart';

import 'package:flutter/material.dart';

class NavBarAdmin extends StatefulWidget {
  const NavBarAdmin({super.key});

  @override
  State<NavBarAdmin> createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  var index = 0;

  final bottom = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
  ];
  final List<Widget> screens = [
    const HomePageAdmin(), // Replace with the appropriate widget for your home page// Replace with the appropriate widget for the second item
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
