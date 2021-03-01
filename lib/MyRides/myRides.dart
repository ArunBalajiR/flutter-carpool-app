import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klndrive/MyRides/acceptedRides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../misc/convertTime.dart';
import '../misc/phoneCall.dart';

class MyRides extends StatefulWidget {
  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  // List that contains requests from users
  List<AcceptedRide> _rides = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRides();
  }

  Future<dynamic> fetchRides() async {
    _isLoading = false;

    SharedPreferences pref = await SharedPreferences.getInstance();

    return http
        .get("http://192.168.43.112:8000/api/user/" + pref.getString('token'))
        .then((response) {
      final List<AcceptedRide> fetchedRides = [];
      //responseData gives user's accepted rides list
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        setState(() {
          _isLoading = false;
        });
      }
      // print(responseData); //working till here

      var length = responseData.length;
      for (var i = 0; i < length; i++) {
        final AcceptedRide request = AcceptedRide(
          acceptedDriverName: responseData[i]['driverName'],
          acceptedDriverNumber: responseData[i]['driverPhone'],
          destination: responseData[i]['location'],
          time: responseData[i]['time'],
          rate: responseData[i]['rate'],
        );
        fetchedRides.add(request);
      }

      setState(() {
        _rides.clear();
        _rides.addAll(fetchedRides);
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        print(e);
      });
    });
  }

  Future<dynamic> _onRefresh() {
    return fetchRides();
  }

  Widget _buildRidesList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      key: _refreshIndicatorKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _rides.length,
              itemBuilder: (BuildContext context, int index) {
                return _ridesCards(context, index);
              },
            ),
          )
        ],
      ),
    );
  }

  // Cards showing accepted rides
  Widget _ridesCards(BuildContext context, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/accountAvatar.jpg"),
          radius: 25,
        ),
        title: ListTile(
          title: Text(
            _rides[index].acceptedDriverName,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          subtitle: Text(_rides[index].destination + " : " + convertTimeTo12Hour(_rides[index].time)),
        ),
        trailing: Container(
          child: Text(
            _rides[index].rate + " Rs",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Colors.green,
            ),
            title: GestureDetector(
              child: Text(_rides[index].acceptedDriverNumber)),
              onTap: () => openPhone(_rides[index].acceptedDriverNumber)
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Rides"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildRidesList(),
    );
  }
}
