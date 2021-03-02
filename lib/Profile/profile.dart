import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePage> {
  // final _firestore = FirebaseFirestore.instance;
  String name = "";
  String year = "";
  String branch = "";
  String phone = "";

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(()  {

      name = pref.getString('userName');
      branch = pref.getString('userBranch');
      year = pref.getString('userYear');
      phone = pref.getString('phone');
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
                Hero(
                  tag: "profile",
                  child: Container(
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
                ),
                SizedBox(height: 40.0),
                Container(
                  child: Text(
                    "name",
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
                      "getBranch(branch)",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        // fontStyle: FontStyle.it,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '" - " + getYear(year)',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "'Phone: ' + phone",
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
                  width: 290,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      _signOut();
                      Navigator.pushNamed(context,'/otphome');
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      await preferences.clear();
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
  if (branch == 'CSE') return 'Computer Science';
  if (branch == 'ECE') return 'Electronics & Communication';
  if (branch == 'IT') return 'Information Technology';
  if (branch == 'EEE') return 'Electronics & Electrical';
  if (branch == 'MECH') return 'Mechanical Engineering';
  if (branch == 'AUTO') return 'Automobile Engineering';
  if (branch == 'EIE') return 'Electronics & Instrumentation';
  return branch;
}

getYear(String year) {
  if (year == "1") return '1st Year';
  if (year == "2") return '2nd Year';
  if (year == "3") return '3rd Year';
  if (year == "4") return '4th Year';
  return year;
}
