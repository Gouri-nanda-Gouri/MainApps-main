import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psycologist_app/home.dart';
import 'package:psycologist_app/myprofile.dart';

class homep extends StatefulWidget {
  const homep({super.key});

  @override
  State<homep> createState() => _homepState();
}

class _homepState extends State<homep> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    Homepage(),
    Container(child: Center(child: Text("Search Page"))),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: (Colors.black)),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
