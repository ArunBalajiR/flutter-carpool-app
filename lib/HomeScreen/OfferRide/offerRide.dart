import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RideRequestScreen/rideRequestList.dart';

class OfferRide extends StatefulWidget {
  @override
  _OfferRideState createState() => _OfferRideState();
}

class _OfferRideState extends State<OfferRide> {
  bool carRegistered = true;

  @override
  void initState() {
    super.initState();
    //checks for what screen to be displayed
    screenCheck();
  }

  screenCheck() {
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        carRegistered = pref.getBool('carpool');        
      });
    }).catchError((e){
      print(e);
    });
  }

  //callback executed when someone register a car -- decides again which widget to load
  reloadOfferRide(val) {
    setState(() {
     carRegistered = val; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return carRegistered ? 
    RideRequestList() 
    : 
    NotRegistered(carRegistered,reloadOfferRide);
  }
}


// Widget displayed when no Car is registered
class NotRegistered extends StatefulWidget {

  bool car;
  Function(bool) callback;

  NotRegistered(this.car,this.callback);

  @override
  _NotRegisteredState createState() => _NotRegisteredState();
}

class _NotRegisteredState extends State<NotRegistered> {
  registerCar(BuildContext context) {
    // alertbox
    final alertDialog = AlertDialog(
      title: Text(
        "Register vehicle",
        style: TextStyle(
          color: Color(0xff474949)
        ),
      ),
      content: Text(
        "Would you like to pool your Car/Bike?",
        style: TextStyle(color: Colors.grey),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Yes, I would like to"),
          onPressed: (){
            changeSharedPreference();
          },
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(
      context: context, builder: (BuildContext context) => alertDialog,
      barrierDismissible: false,
    );
  }

  //change the value in SP and make a callback to parent to reload widget 
  changeSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('carpool', true);
    Navigator.of(context).pop();
    widget.callback(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Image(
              width: MediaQuery.of(context).size.width * 0.7,
              image: AssetImage("assets/carRegister.jpg"),
              // fit: BoxFit.contain,
            ),
            Text(
              "Oops! You have no Car/Bike registred",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                onPressed: () => registerCar(context),
                child: Center(
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
