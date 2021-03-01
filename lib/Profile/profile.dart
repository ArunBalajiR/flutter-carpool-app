import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePage> {
  String name = "";
  String year = "";
  String branch = "";
  String phone = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('userName');
      branch = pref.getString('userBranch');
      year = pref.getString('userYear');
      phone = pref.getString('userPhone');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 20),
        child: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "My Profile",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.black.withOpacity(1)),
            clipper: GetClipper(),
          ),
          Positioned(
            width: 350.0,
            left: 5,
            top: MediaQuery.of(context).size.height / 7,
            child: Column(
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(
                          image: AssetImage('assets/accountAvatar.jpg'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(105.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 9.0, color: Colors.black)
                      ]),
                ),
                SizedBox(height: 40.0),
                Container(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 25.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      getBranch(branch),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        // fontStyle: FontStyle.it,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      " - " + getYear(year),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'Phone: ' + phone,
                  style: TextStyle(
                    fontSize: 20.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image(
                  image: AssetImage("assets/signUp.jpg"),
                  // width: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 3.5);
    path.lineTo(size.width + 60500, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

getBranch(String branch) {
  if (branch == 'CSA' || branch == 'CSB') return 'Computer Science';
  if (branch == 'ECA' || branch == 'ECB') return 'Electronics & Communication';
  if (branch == 'EB') return 'Electronics & Biomedical';
  if (branch == 'EEE') return 'Electronics & Electrical';
  return branch;
}

getYear(String year) {
  if (year == "1") return '1st Year';
  if (year == "2") return '2nd Year';
  if (year == "3") return '3rd Year';
  if (year == "4") return '4th Year';
  return year;
}
