import 'package:flutter/material.dart';
import 'confirmCard.dart';

class FindaRide extends StatefulWidget {
  @override
  _FindaRideState createState() => _FindaRideState();
}

class _FindaRideState extends State<FindaRide> {
  // Destination
  String destination = "";

  TimeOfDay pickedTime = TimeOfDay.now();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay response = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );
    if (response != null && response != pickedTime) {
      setState(() {
        pickedTime = response;
        print(pickedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width/1.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Starting Location
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(
                      "Model Engineering College",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    subtitle: Text("Thrikkakara"),
                  ),
                ),
                // Destination
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: TextField(
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        hintText: "Destination",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                      ),
                      onChanged: (String val) {
                        setState(() {
                          destination = val;
                        });
                      },
                    ),
                  ),
                ),
                // Time
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // background
                      onPrimary: Colors.white, // foreground
                    ),

                    child:
                        Text("Select Time", style: TextStyle(fontSize: 16.0)),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                // Confirm button
                SizedBox(
                  child: ElevatedButton(

                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              ConfirmCard(destination, pickedTime)
                      ).then((snack) => ScaffoldMessenger.of(context).showSnackBar(snack));

                    },

                    child: Text(
                      "Find A Ride",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
