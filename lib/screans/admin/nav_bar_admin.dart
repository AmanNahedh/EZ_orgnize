import 'package:ez_orgnize/screans/admin/home_page_admin.dart';
import 'package:ez_orgnize/screans/home_page_useer.dart';
import 'package:ez_orgnize/screans/profile.dart';
import 'package:flutter/material.dart';

class NavBarAdmin extends StatefulWidget {
  const NavBarAdmin({super.key});

  @override
  State<NavBarAdmin> createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  var index = 0;

  final bottom = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
  ];
  final List<Widget> screens = [
    HomePageAdmin(), // Replace with the appropriate widget for your home page
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
