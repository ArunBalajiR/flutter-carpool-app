import 'package:flutter/material.dart';
import 'giveaRide.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }
  // Bottom navigation bar
  int _currentIndex = 0;

  void onTabTapped(int index) {
    if (index == 1) Navigator.pushNamed(context, '/myrides');
    if (index == 2) Navigator.pushNamed(context, '/profile');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FindaRide(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "ShareRide"),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike), label: "FindRide"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: "Profile"),
        ],
      ),
    );




  }

  @override
  void dispose() {
    super.dispose();
  }
}
