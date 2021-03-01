import 'package:flutter/material.dart';
import 'package:klndrive/MyRequests/myRequestClass.dart';
import 'package:klndrive/misc/convertTime.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyRequestList extends StatefulWidget {
  @override
  _MyRequestListState createState() => _MyRequestListState();
}

class _MyRequestListState extends State<MyRequestList> {
  bool accept = true;

  // List that contains requests from users
  List<MyRequest> _requests = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<dynamic> fetchRequests() async {
    _isLoading = false;

    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('token');

    return http
        .get("http://192.168.43.112:8000/api/request/myrequest/" + userId)
        .then((response) {
      final List<MyRequest> fetchedRequests = [];
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        setState(() {
          _isLoading = false;
        });
      }

      var length = responseData.length;
      for (var i = 0; i < length; i++) {
        final MyRequest request = MyRequest(
          requestId: responseData[i]['_id'].toString(),
          destination: responseData[i]['location'],
          time: responseData[i]['time'],
        );
        fetchedRequests.add(request);
      }

      setState(() {
        _requests.clear();
        _requests.addAll(fetchedRequests);
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        print(e);
      });
    });
  }

  deleteRequest(String id) {
    http.delete("http://192.168.43.112:8000/api/request/" + id).then((response) {
      print(response);
    }).catchError((e) {
      print(e);
    });
  }

  Future<dynamic> _onRefresh() {
    return fetchRequests();
  }

  Widget _buildRequestList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      key: _refreshIndicatorKey,
      child: ListView.builder(
        itemCount: _requests.length,
        itemBuilder: (BuildContext context, int index) {
          return _requestCards(context, index);
        },
      ),
    );
  }

  // Cards showing user requests
  Widget _requestCards(BuildContext context, int index) {
    return Dismissible(
      key: Key(UniqueKey().toString()), 
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(Icons.delete,color: Colors.white),
          ],
        ),
      ),
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/accountAvatar.jpg"),
              radius: 25,
            ),
            title: Text(_requests[index].destination),
            subtitle:
                Text("Time: " + convertTimeTo12Hour(_requests[index].time)),
            trailing: accept == true
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.info,
                  ),
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        final bool res = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Text("Are you sure you wish to delete this request?"),
              actions: <Widget>[
                TextButton(
                  child: Text("delete"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                TextButton(
                  child: Text("cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            );
          }
        );
        return res;
      },
      onDismissed: (direction) {
         //send a delete request
        String requestId = _requests[index].requestId;
        deleteRequest(requestId);

        setState(() {
         _requests.removeAt(index); 
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request deleted"),backgroundColor: Colors.black,));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Requests"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                child: Center(
                  child: Text(
                    "Swipe to delete",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildRequestList(),
            ),
          ],
        ));
  }
}
