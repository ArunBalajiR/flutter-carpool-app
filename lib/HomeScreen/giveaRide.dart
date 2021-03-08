import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klndrive/HomeScreen/autocompletePrediction.dart';
import 'package:klndrive/sharedPreferences/sharedPreferences.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:klndrive/misc/convertTime.dart';
import 'package:klndrive/HomeScreen/placepredictions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class FindaRide extends StatefulWidget {
  @override
  _FindaRideState createState() => _FindaRideState();
}

class _FindaRideState extends State<FindaRide> {
  //texxtediting
  final _controller = TextEditingController();
  final _setPriceController = TextEditingController();

  //Google map variables
  Position position;
  bool mapToggle = false;

  GoogleMapController _mapController;

  double _originLatitude, _originLongitude;
  LatLng placeCords, startCords, endCords;
  double _destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  String _googleAPiKey = "AIzaSyAUGbmKdakEcP5AA21mBQtyWw3EgyqBf0o";
  String _placesAPIKey = 'ge-29f1f4bb7c8e8f27';
  String mapStyle;
  BitmapDescriptor bitmapImage;

  var client = http.Client();

  //In app necessary variables
  var inputFormat = DateFormat('h:mm a dd/MM/yyyy');

  String price;

  DateTime dateTime;
  final Color darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);

  List<PlacePredictions> placePredictionList = [];

  //Search/Create variables

  String to = "";

  //sharerideconfirmation variables
  String name = "";
  String year = "";
  String branch = "";
  String phone = "";
  String vehicleno = "";
  String email = "";

  LatLng pickUpPoint;
  // ignore: deprecated_member_use
  List<LatLng> randPoints = new List<LatLng>();
  // ignore: deprecated_member_use
  List<String> selectedPoints = new List<String>();

  //booleans for widgets' visibility
  bool showStartingScreen = true;
  bool isTouchable = false;

  //firestore instancce
  final _firestore = FirebaseFirestore.instance;

  //custom icon
  Future<BitmapDescriptor> _createMarkerImageFromAsset(String iconPath) async {
    ImageConfiguration configuration = ImageConfiguration();
    bitmapImage =
        await BitmapDescriptor.fromAssetImage(configuration, iconPath);
    return bitmapImage;
  }

  void _currentLocation() async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 17.0,
      ),
    ));
  }

  void getCurrentPosition() async {
    Position currentPosition = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = currentPosition;
      mapToggle = true;
      print(position);
    });

    CollectionReference location =
        FirebaseFirestore.instance.collection('location');
    // FirebaseAuth _auth = FirebaseAuth.instance;
    // String uid = _auth.currentUser.uid.toString();
    final coordinated = new Coordinates(position.latitude, position.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinated);
    var firstAddress = address.first;

    location.add({
      'username': await MySharedPreferences.instance.getStringValue("userName"),
      'locationpoint': GeoPoint(position.latitude, position.longitude),
      'address': firstAddress.addressLine,
      'postalcode': firstAddress.postalCode,
      'locality': firstAddress.locality,
    });

    print(await MySharedPreferences.instance.getStringValue("userName"));
    print(position.latitude);
    print(position.longitude);
    print(firstAddress.addressLine);
    print(firstAddress.postalCode);
    print(firstAddress.locality);

    //set custom icon
    _createMarkerImageFromAsset("assets/locationpin.png");

    //calling marker function

    await getMarkerData();
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  fetchData() async {
    MySharedPreferences.instance
        .getStringValue("userName")
        .then((value) => setState(() {
              name = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userBranch")
        .then((value) => setState(() {
              branch = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userYear")
        .then((value) => setState(() {
              year = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userPhone")
        .then((value) => setState(() {
              phone = value;
            }));
    MySharedPreferences.instance
        .getStringValue("vechicleno")
        .then((value) => setState(() {
              vehicleno = value;
            }));
    MySharedPreferences.instance
        .getStringValue("email")
        .then((value) => setState(() {
              email = value;
            }));
  }

  void initMarker(specify, specifyID) async {
    var markerIdval = specifyID;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
      markerId: markerId,
      icon: bitmapImage,
      position: LatLng(specify['locationpoint'].latitude,
          specify['locationpoint'].longitude),
      infoWindow:
          InfoWindow(title: specify['username'], snippet: specify['address']),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance
        .collection('location')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          initMarker(snapshot.docs[i].data(), snapshot.docs[i].id);
        }
      }
    });
  }

  Set<Marker> getMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("one"),
        position: LatLng(9.880892, 78.112317),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "one"),
      )
    ].toSet();
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
          mapToggle
              ? _googleMap(context)
              : Center(
                  child: CircularProgressIndicator(),
                ),
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
                _fillField("To: ", Colors.red, 10.0, Icons.location_pin),
                _dateField(),
              ],
            ),
          ),
          _customButton(Alignment.bottomRight, 145.0, Icons.my_location, "Me",
              _onLocationPressed),
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
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              controller: _controller,

              decoration:InputDecoration(
                filled: true,
                prefixIcon: Icon(
                  Icons.location_on,
                  color: clr,
                ),
                hintText: str,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                fillColor: Colors.white,
              ),
          ),
          suggestionsCallback: (pattern) async {
            return CitiesService.getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            _controller.text = suggestion;
          },






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
              format: inputFormat,
              onChanged: (DateTime dt) {
                dateTime = dt;
              },
              resetIcon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0)),
                  //suffixIcon: Icon(Icons.calendar_today, color: Colors.black,),
                  fillColor: Colors.white,
                  labelText: "Date: ",
                  labelStyle: TextStyle(color: Colors.black)),
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
        padding:
            EdgeInsets.only(right: 10.0, bottom: bottom, left: 10.0, top: 10.0),
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
    if (_areFieldsFilled()) {}
  } //onSearchPressed

  //the method called when the user presses the create button
  _onCreatePressed() {
    print("on create pressed");
    if (_areFieldsFilled()) {
      to = _controller.text;
      Alert(
          context: context,
          title: "$to,${DateFormat('h:mm a dd/MM/yyyy').format(dateTime)}",
          content: Column(
            children: <Widget>[
              //userdetails
              Container(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/accountAvatar.jpg"),
                  ),
                  title: Text(
                    "Name: " + name,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Text(
                        "Branch: " + branch,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Year: " + year,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Ride Details -- Destination and Time
              Container(
                // color: Colors.cyan,
                child: ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  ),
                  title: Text(
                    _controller.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Time : " + convertTimeTo12Hour(dateTime),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                // color: Colors.greenAccent,
                child: ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                    color: Colors.blue,
                  ),
                  title: TextField(
                    controller: _setPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: TextButton(
                    child: Text(
                      "Set Price",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      _showToast("Price Requested");
                      FocusScope.of(context).requestFocus(null);
                      setState(() {
                        price = _setPriceController.text;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () {
                _firestore.collection('rides').add({
                  'sender': name,
                  'destination': to,
                  'ridetime': convertTimeTo12Hour(dateTime),
                  'price': price,
                  'phone': phone,
                  'upi': email,
                  'vechicleno': vehicleno,
                  'timestamp': Timestamp.now(),
                });
                Navigator.pop(context);
              },
              child: Text(
                "Offer Ride",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
      _controller.clear();
    }
  } //onCreatePressed

  _onLocationPressed() {
    _currentLocation();
  }

  bool _areFieldsFilled() {
    if (_controller.text.isEmpty) {
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: false,
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
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = address.first;
    String name = first.addressLine;
    return name;
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    // _mapController.setMapStyle(mapStyle);
  }

  // method that adds the marker to the map
  _addMarker(
      LatLng position, String id, BitmapDescriptor descriptor, String info) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: InfoWindow(title: info));
    markers[markerId] = marker;
  }

  // method that creates the polyline given the from and to geolocation
  _getPolyline(String name) async {
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
      _googleAPiKey,
      _originLatitude,
      _originLongitude,
      _destLatitude,
      _destLongitude,
    );
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId(name);
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _clearPolylines() {
    polylineCoordinates.clear();
    polylines.clear();
  }

  _clearMarkers() {
    markers.clear();
  }
}
