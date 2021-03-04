// import 'package:flutter/material.dart';
// import 'FindRide/findaRide.dart';
// import 'OfferRide/offerRide.dart';
//
//
//
//
//
//
//   DefaultTabController(
//   length: 2,
//   child: Scaffold(
//   // AppBar
//   appBar: AppBar(
//   backgroundColor: Colors.black,
//   centerTitle: true,
//   leading: GestureDetector(
//   onTap: () {
//   Navigator.of(context).pushNamed('/profile');
//   },
//   child: Padding(
//   padding: EdgeInsets.all(12),
//   child: Hero(
//   tag: "profile",
//   child: CircleAvatar(
//   backgroundImage: AssetImage("assets/accountAvatar.jpg"),
//   ),
//   )
//   ),
//   ),
//   actions: <Widget>[
//   PopupMenuButton(
//   onSelected: (val) {
//   if(val == 1)
//   {
//   //navigate to credits page
//   Navigator.of(context).pushNamed('/credits');
//   }
//   },
//   itemBuilder: (context) => [
//   PopupMenuItem(
//   value: 1,
//   child: Text("Credits"),
//   )
//   ],
//   ),
//   ],
//   bottom: TabBar(
//   indicatorColor: Colors.white,
//   tabs: <Widget>[
//   Tab(
//   icon: Icon(Icons.phone_android),
//   text: "Find Ride",
//   ),
//   Tab(
//   icon: Icon(Icons.local_taxi),
//   text: "Offer Ride",
//   )
//   ],
//   ),
//   title: Text("KLN Drive"),
//   ),
//   body: TabBarView(
//   children: <Widget>[
//   // Find a Ride
//   FindaRide(),
//   // Offer Ride
//   OfferRide(),
//   ],
//   ),
//   // Bottom Navigation
//   // bottomNavigationBar: BottomNavigationBar(
//   //   currentIndex: _currentIndex,
//   //   onTap: onTabTapped,
//   //   selectedItemColor: Colors.black,
//   //   items: [
//   //     BottomNavigationBarItem(
//   //         icon: Icon(Icons.home), label: "Home"),
//   //     BottomNavigationBarItem(
//   //         icon: Icon(Icons.directions_bike), label: "My Rides"),
//   //     BottomNavigationBarItem(
//   //         icon: Icon(Icons.class_), label: "My Requests"),
//   //   ],
//   // ),
//   ),
//   );
// }
// }
