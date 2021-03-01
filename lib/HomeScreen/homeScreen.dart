import 'package:flutter/material.dart';
import 'FindRide/findaRide.dart';
import 'OfferRide/offerRide.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Bottom navigation bar
  int _currentIndex = 0;

  void onTabTapped(int index) {
    if (index == 1) Navigator.pushNamed(context, '/myrides');
    if (index == 2) Navigator.pushNamed(context, '/myrequests');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // AppBar
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/accountAvatar.jpg"),
              )
            ),
          ),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (val) {
                if(val == 1)
                {
                  //navigate to credits page
                  Navigator.of(context).pushNamed('/credits');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Credits"),
                )
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.phone_android),
                text: "Find Ride",
              ),
              Tab(
                icon: Icon(Icons.local_taxi),
                text: "Offer Ride",
              )
            ],
          ),
          title: Text("MEC Drive"),
        ),
        body: TabBarView(
          children: <Widget>[
            // Find a Ride
            FindaRide(),
            // Offer Ride
            OfferRide(),
          ],
        ),
        // Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_bike), title: Text("My Rides")),
            BottomNavigationBarItem(
                icon: Icon(Icons.class_), title: Text("My Requests")),
          ],
        ),
      ),
    );
  }
}
