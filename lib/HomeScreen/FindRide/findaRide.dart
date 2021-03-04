import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';


// import 'package:geolocator/geolocator.dart';

class FindaRide extends StatefulWidget {
  @override
  _FindaRideState createState() => _FindaRideState();
}

class _FindaRideState extends State<FindaRide> {

  //Google map variables
  GoogleMapController _mapController;
  double _originLatitude, _originLongitude;
  LatLng placeCords, startCords, endCords;
  double _destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  String _googleAPiKey = "AIzaSyAUGbmKdakEcP5AA21mBQtyWw3EgyqBf0o";
  String mapStyle;
  Completer<GoogleMapController> _controller = Completer();

  //In app necessary variables
  final format = DateFormat("dd-MM-yyyy HH:mm");
  DateTime dateTime;
  final Color darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);

  //Search/Create variables
  String from = "";
  String to = "";

  LatLng pickUpPoint;
  List<LatLng> randPoints = new List<LatLng>();
  List<String> selectedPoints = new List<String>();

  //booleans for widgets' visibility
  bool showStartingScreen = true;
  bool isTouchable = false;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return homeScaffold();
  }

  Widget homeScaffold() {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: <Widget>[
          _googleMap(context),
          _startingScreen(showStartingScreen),

        ],
      ),
    );
  }

  Widget _startingScreen(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 250.0,
            child: ListView(
              children: <Widget>[
                _fillField("From: ", Colors.blue, 10.0, Icons.location_pin),
                _fillField("To: ", Colors.red, 10.0, Icons.location_pin),
                _dateField(),
              ],

            ),
          ),
          _customButton(Alignment.bottomRight, 80.0, Icons.search, "Search",
              _onSearchPressed),
          _customButton(Alignment.bottomRight, 15.0, Icons.add, "Create",
              _onCreatePressed),
        ],
      ),
    );
  }

  Align _fillField(String str, Color clr, double top, IconData icon) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: top),
        child: TextField(

          cursorColor: Colors.black,
          // controller: appState.locationController,
          decoration: InputDecoration(
            filled: true,
            prefixIcon: Icon(Icons.location_on,color: clr,),

            hintText: str,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
            fillColor: Colors.white,
          ),
        ),
      ),

    );
  }

  Align _dateField() {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: DateTimeField(
              format: format,
              onChanged: (DateTime dt) {
                dateTime = dt;
              },
              resetIcon: Icon(Icons.clear, color: Colors.black,),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  //suffixIcon: Icon(Icons.calendar_today, color: Colors.black,),
                  fillColor: Colors.white,
                  labelText: "Date: ",
                  labelStyle: TextStyle(
                      color: Colors.black
                  )
              ),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            )));
  } //dateField

  Widget _customButton(Alignment alignment, double bottom, IconData icon,
      String label, Function onPressed) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(
            right: 10.0, bottom: bottom, left: 10.0, top: 10.0),
        child: SizedBox(
          height: 50.0,
          width: 120.0,
          child: ElevatedButton.icon(
            icon: Icon(icon),
            label: Text(label),
            onPressed: () {
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),

            ),
          ),
        ),
      ),
    );
  }

  //the method called when the user presses the search button
  _onSearchPressed() async {
    print('search button pressed');
    if (_areFieldsFilled()) {

    }
  } //onSearchPressed


  //the method called when the user presses the create button
  _onCreatePressed() {
    print("on create pressed");
    if (_areFieldsFilled()) {

    }
  } //onCreatePressed

  bool _areFieldsFilled() {
    if (from == "") {
      _showToast("Missing 'From' field!");
      return false;
    }
    if (to == "") {
      _showToast("Missing 'To' field!");
      return false;
    }
    if (dateTime == null) {
      _showToast("Missing 'Date' field!");
      return false;
    }
    return true;
  }

  _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 1,
    );
  }


  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(37.9838, 23.7275),
            zoom: 15
        ),
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
        onTap: _onMapTap,
      ),
    );
  }


  void _onMapTap(LatLng point) {
    if (isTouchable) {
      _showPointDialog(point);
    }
  }

  void _showPointDialog(LatLng point) async {
    final String name = await _getAddressFromLatLng(point);
    print(name);
  }

  Future<String> _getAddressFromLatLng(LatLng point) async {
    final coordinates = new Coordinates(point.latitude, point.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = address.first;
    String name = first.addressLine;
    return name;
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    // _mapController.setMapStyle(mapStyle);
  }

  // method that adds the marker to the map
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor,
      String info) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: InfoWindow(title: info
        ));
    markers[markerId] = marker;
  }

  _clearMarkers() {
    markers.clear();
  }
}