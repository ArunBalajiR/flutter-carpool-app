import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klndrive/sharedPreferences/sharedPreferences.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class RideDetailCard extends StatelessWidget {
  RideDetailCard({this.rideSender, this.rideDestination, this.rideTime,this.ridePrice, this.ridePhone, this.rideUPI,this.rideVehicleNo, this.timestamp, this.isMe});

  final String rideSender;
  final String rideDestination;
  final String rideTime;
  final String ridePrice;
  final String ridePhone;
  final String rideUPI;
  final String rideVehicleNo;
  final Timestamp timestamp;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final dateTime =
    DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$rideSender",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.blue : Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    " I am goin to $rideDestination at $rideTime . You have to pay me $ridePrice using this upi $rideUPI call me $ridePhone Vehicledetails are here $rideVehicleNo",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: isMe ? Colors.white : Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:6.0),
                    child: Text("${DateFormat('h:mm a').format(dateTime)}",style: TextStyle(
                      fontSize: 9.0,
                      color: isMe ? Colors.white.withOpacity(0.5) : Colors.black54.withOpacity(0.5),
                    ),),
                  ),],
              ),
            ),
          ),
        ],
      ),
    );

  }


}
