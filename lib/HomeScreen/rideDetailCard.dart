import 'file:///F:/Flutter/klndrive/lib/misc/themes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RideDetailCard extends StatelessWidget {

  final String rideSender, rideDestination, rideTime, ridePrice, ridePhone, rideUPI, rideVehicleNo;
  final Timestamp timestamp;
  final bool isMe;

  RideDetailCard({this.rideSender, this.rideDestination, this.rideTime,this.ridePrice, this.ridePhone, this.rideUPI,this.rideVehicleNo, this.timestamp, this.isMe});

  initiateTransaction() async {
    String upiUrl =
        "upi://pay?pa=$rideUPI&pn=$rideSender&am=$ridePrice&cu=INR;&tn=Thank You Friend..!";
    await launch(upiUrl).then((value) {
      print(value);
    }).catchError((err) => print(err));
  }


  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return isMe ? Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
                left: BorderSide(
                    color: Colors.blue,
                    width: 7.0
                )
            )
        ),
        child: Material(

          elevation: 4.0,
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
          child: Stack(
            children: <Widget>[

              Positioned(
                bottom: 5.0,
                right: 70.0,
                width: 120.0,
                child: Container(
                  height: 120.0,

                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, bottom: 0.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "SHARED RIDE DETAILS",
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                            ),

                          ],
                        ),
                        Spacer(),
                        ClipOval(
                          child: Image.asset(
                            'assets/accountAvatar.jpg',
                            fit: BoxFit.cover,
                            height: 45.0,
                            width: 45.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              rideDestination,
                              style: boldBlackLargeTextStyle,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  rideTime,
                                  style: normalGreyTextStyle,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),

                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "₹ $ridePrice",
                          style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),

                  SizedBox(
                    height: 16.0,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 0.0,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: Text("Your ride was shared at ${DateFormat('h:mm a').format(dateTime)} .\nWait for confirmation call.",textAlign: TextAlign.center,style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black.withOpacity(0.5),
                        ),),),
                        SizedBox(height:40),

                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    ) : Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        elevation: 4.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        child: Stack(
          children: <Widget>[

            Positioned(
              bottom: 5.0,
              right: 70.0,
              width: 120.0,
              child: Container(
                height: 120.0,

              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 0.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            rideDestination,
                            style: boldBlackLargeTextStyle,
                          ),
                          Text(
                            rideTime,
                            style: normalGreyTextStyle,
                          ),
                        ],
                      ),
                      Spacer(),
                      ClipOval(
                        child: Icon(
                          Icons.account_circle_rounded,
                          size: 45,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            rideSender,
                            style: boldBlackLargeTextStyle,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                ridePhone,
                                style: normalGreyTextStyle,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 1.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1.0),
                                  ),
                                  border: Border.all(color: greyColor),
                                ),
                                child: Text(
                                  rideVehicleNo,
                                  style: normalGreyTextStyle,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Spacer(),

                      Text(
                        "₹ $ridePrice",
                        style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),

                SizedBox(
                  height: 16.0,
                ),
                Divider(
                  color: Colors.black,
                  height: 0.0,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: isMe ? Row(children:[Text("Ride Submited"),],) : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton.icon(
                        icon: Icon(Icons.call),
                        label: Text("CALL"),
                        // onPressed: () => url.launch("tel://+917904402214"),
                        onPressed: () async {
                          FlutterPhoneDirectCaller.callNumber("$ridePhone");

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                      SizedBox(width:20),
                      ElevatedButton(
                        child: Text("PAY AND CONFIRM"),
                        onPressed: () {
                          initiateTransaction();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                      SizedBox(height:60),

                    ],
                  ),
                ),
              ],
            ),
            Padding(

              padding: const EdgeInsets.only(top:225.0,left: 280),
              child: Text("${DateFormat('h:mm a').format(dateTime)}",style: TextStyle(
                fontSize: 10.0,
                color: Colors.black.withOpacity(0.5),
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
