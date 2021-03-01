 import 'package:flutter/material.dart';

 //class to represent each accepted ride of a user
 class AcceptedRide {
  final String acceptedDriverName;
  final String acceptedDriverNumber;
  final String destination; 
  final String time;
  final String rate;

  AcceptedRide({
    @required this.acceptedDriverName,
    @required this.acceptedDriverNumber,
    @required this.destination,
    @required this.time,
    @required this.rate,
  });
 }