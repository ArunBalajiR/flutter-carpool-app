import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klndrive/sharedPreferences/sharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:klndrive/HomeScreen/rideDetailCard.dart';

final _firestore = FirebaseFirestore.instance;
final phone = FirebaseAuth.instance.currentUser.phoneNumber;
var loggedInuser;

class FindaRide extends StatefulWidget {
  @override
  _FindaRideState createState() => _FindaRideState();
}

class _FindaRideState extends State<FindaRide> {

  String user = "";

  void getCurrentUserName() async {
    try {
      final user = MySharedPreferences.instance
          .getStringValue("userName");
      if (user != null) {
        loggedInuser = user;
        print(loggedInuser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Find a Ride"),

      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RideStream(),
          ],
        ),
      ),
    );
  }
}



class RideStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('rides')
      // Sort the messages by timestamp DESC because we want the newest messages on bottom.
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // If we do not have data yet, show a progress indicator.
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Create the list of message widgets.

        List<Widget> rideWidgets = snapshot.data.docs.map<Widget>((r) {
          final data = r.data();
          final rideSender = data['sender'];
          final rideDestination = data['destination'];
          final rideTime = data['ridetime'];
          final ridePrice = data['price'];
          final ridePhone = data['phone'];
          final rideUPI = data['upi'];
          final rideVehicleNo = data['vechicleno'];
          final timeStamp = data['timestamp'];
          return RideDetailCard(
            rideSender: rideSender,
            rideDestination: rideDestination,
            rideTime : rideTime,
            ridePrice : ridePrice,
            ridePhone : ridePhone,
            rideUPI : rideUPI,
            rideVehicleNo : rideVehicleNo,
            timestamp: timeStamp,
            isMe: ridePhone == phone,
          );
        }).toList();



        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: rideWidgets,
          ),
        );
      },
    );
  }
}
