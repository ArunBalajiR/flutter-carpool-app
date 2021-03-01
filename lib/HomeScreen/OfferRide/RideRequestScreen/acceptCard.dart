import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klndrive/misc/convertTime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setPrice.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AcceptCard extends StatefulWidget {

  String destination;
  String time;
  String requestedUserId;
  AcceptCard(this.destination,this.time,this.requestedUserId);
  @override
  _AcceptCardState createState() => _AcceptCardState();
}

class _AcceptCardState extends State<AcceptCard> {
  String price = "0.0";

  String username = "";
  String branch = "";
  String year = "";
 
  @override
  void initState() {
    super.initState();
    //make a network call to get corresponding user details
    _getUserDetails();
  }

  _getUserDetails() {
    http.get("http://192.168.43.112:8000/api/user/info/"+ widget.requestedUserId).
    then((response) {
      print(response.body);
      final Map<String,dynamic> user = json.decode(response.body);

      setState(() {
       username = user["name"];
       branch = user["branch"];
       year = user["year"]; 
      });
    }).catchError((e){
      print(e);
    });
  }

  _offerRide(BuildContext context) {

    // alertbox
    final alertDialog = AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          SizedBox(
            width: 40.0,
          ),
          Text(
            "Notifying user",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
    showDialog(
      context: context, builder: (BuildContext context) => alertDialog,
      barrierDismissible: false,
    );

    _postOfferRequest();

  }

  _postOfferRequest() async { 

    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = "http://192.168.43.112:8000/api/request/"+widget.requestedUserId;
    Map<String,String> offerRequest = {
      'driverName'  : pref.getString('userName'),
      'driverPhone' : pref.getString('userPhone'),
      'location'    : widget.destination,
      'time'        : widget.time,
      'rate'        : price
    };


    //test code
    http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(offerRequest)
    ).then((response) {
      final Map<String,dynamic> responseData = json.decode(response.body);
      print(responseData);

      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Navigator.of(context).pop("success");
      });

    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height/2,
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          // User details
          Container(
            // color: Colors.blueAccent,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("assets/accountAvatar.jpg"),
              ),
              title: Text("Name: "+username,style: TextStyle(
                color: Colors.white
              ),),
              subtitle: Row(
                children: <Widget>[
                  Text("Branch: "+branch,style: TextStyle(
                    color: Colors.white,
                  ),),
                  SizedBox(width: 5),
                  Text("Year: "+year,style: TextStyle(
                    color: Colors.white,
                  ),),
                ],
              ),
            ),
          ),
          // Ride Details -- Destination and Time
          Container(
            // color: Colors.cyan,
            child: ListTile(
              leading: Icon(Icons.location_on,color: Colors.white,),
              title: Text(widget.destination,style: TextStyle(
                color: Colors.white,
              ),),
              subtitle: Text("Time : " + convertTimeTo12Hour(widget.time),style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ),
          //Set Price
          Container(
            // color: Colors.greenAccent,
            child: ListTile(
              leading: Icon(Icons.monetization_on,color: Colors.white,),
              title: Text(
                price.toString() + " Rs",
                style: TextStyle(color: Colors.white),
              ),
              trailing: TextButton(

                child: Text("Set Price"),
                onPressed: (){
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => SetPrice()
                  ).then((newPrice) {
                    print(newPrice);
                    setState(() {
                     price = newPrice; 
                    });
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: MediaQuery.of(context).size.width/1.5,
            child: ElevatedButton(

              child: Text("Offer Ride",style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),),
              onPressed: () => _offerRide(context), 
            ),
          )
        ],
      ),
    );
  }
}
