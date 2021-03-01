import 'package:flutter/material.dart';


//class to represent each user making a request
class RideRequest {
  final String requestedUserId;
  final String destination;
  final String time;

  RideRequest({
    @required this.requestedUserId,
    @required this.destination,
    @required this.time,
  });
} 