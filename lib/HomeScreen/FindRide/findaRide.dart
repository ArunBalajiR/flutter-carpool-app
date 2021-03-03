import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:klndrive/HomeScreen/homebottomsheet.dart';


class FindaRide extends StatefulWidget {
  @override
  _FindaRideState createState() => _FindaRideState();
}

class _FindaRideState extends State<FindaRide> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController _newcontrollerGoogleMap;

  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;

  //geolocator
  Position currentPosition;
  var geoLocator = Geolocator();

Future getCurrentPosition() async {
  LatLng latlngPosition;
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  latlngPosition = LatLng(position.latitude,position.longitude);

}



  static final CameraPosition _clgPosition = CameraPosition(
    target: LatLng(9.837821, 78.164626),
    zoom: 14.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/locationpin.png');
  }

  void _onMapCreated(GoogleMapController controller){
    _controllerGoogleMap.complete(controller);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          position: LatLng(9.8830540, 78.1119752),
          infoWindow: InfoWindow(
            title: "You're Here",

          ),
          icon: mapMarker,

        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,

      children: [
      GoogleMap(
        padding: EdgeInsets.only(
          bottom: 120,
        ),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      onMapCreated: _onMapCreated,
      markers: _markers,
      initialCameraPosition: _clgPosition,

    ),
        HomeBottomSheet(),
      ],
    );
  }
}
