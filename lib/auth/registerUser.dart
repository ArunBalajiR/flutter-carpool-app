import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:klndrive/auth/userData.dart';
import 'package:klndrive/sharedPreferences/sharedPreferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  final String phone;
  SignUp({this.phone});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _controller = TextEditingController();

  String uid;
  String mob;
  //dropdown variables
  List<String> _branch = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'EIE',
    'MECH',
    'AUTO',
  ];



  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form field variables
  String name;
  String phone;
  String email;
  String vehicleNo;
  String branch = 'CSE';
  String year = '1';
  int carpool = 0;
  bool _isVisible = true;

  bool _areFieldsFilled() {
    if (_controller.text.isEmpty) {
      _showToast("Name is required");
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

  void saveUserInfo() async {
    uid = FirebaseAuth.instance.currentUser.uid;
    phone = FirebaseAuth.instance.currentUser.phoneNumber;
    await UserDatabaseService(uid: uid)
        .updateUserData(name, email, branch, year, carpool, vehicleNo);
    // print("stored user details in firestore");

    //save user id from response in local storage

    MySharedPreferences.instance.setStringValue("userName", name);
    MySharedPreferences.instance.setStringValue("userPhone", phone);
    MySharedPreferences.instance.setStringValue("userBranch", branch);
    MySharedPreferences.instance.setStringValue("vechicleno", vehicleNo);
    MySharedPreferences.instance.setStringValue("email", email);
    MySharedPreferences.instance.setStringValue("userYear", year);
    MySharedPreferences.instance.setBoolValue("isLoggedIn", true);
    MySharedPreferences.instance.setIntValue("carpool", carpool);

    // print("stored user data in local storage");
  }

  // Submit the user details to database
  void _submitForm(BuildContext context) async {
    saveUserInfo();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: <Widget>[
          Image(
            //
            height: 250,

            image: AssetImage("assets/signUp.jpg"),
          ),
          // Sign Up container
          Container(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            width: 320.0,
            height: 500.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 15.0),
                    blurRadius: 15.0),
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, -10.0),
                    blurRadius: 10.0)
              ],
            ),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // UserName
                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: "Name", icon: Icon(Icons.account_circle)),
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontFamily: "Poppins"),
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  // Phone
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "UPI ID", icon: Icon(Icons.credit_card_outlined)),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  // Branch
                  Row(
                    children: <Widget>[
                      Text("Branch: ", style: TextStyle(fontSize: 17.0)),
                      Padding(padding: EdgeInsets.all(5.0)),
                      DropdownButton<String>(
                        value: branch,
                        items: _branch.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            branch = value;
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      // Year
                      Text("Year: ", style: TextStyle(fontSize: 17.0)),
                      Padding(padding: EdgeInsets.all(5.0)),
                      DropdownButton<String>(
                        value: year,
                        items: <String>['1', '2', '3', '4']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            year = value;
                          });
                        },
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  // Carpool
                  Row(
                    children: <Widget>[
                      Text(
                        "Do you have a vehicle to pool?",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(2.0)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Yes:", style: TextStyle(fontSize: 17.0)),
                      Radio(
                        activeColor: Colors.green,
                        value: 1,
                        groupValue: carpool,
                        onChanged: (int val) {
                          setState(() {
                            carpool = val;
                            _isVisible = true;
                          });
                        },
                      ),
                      Text("No:", style: TextStyle(fontSize: 17.0)),
                      Radio(
                        activeColor: Colors.green,
                        value: 0,
                        groupValue: carpool,
                        onChanged: (int val) {
                          setState(() {
                            carpool = val;
                            _isVisible = false;
                          });
                        },
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top:10.0,left: 10.0,right: 10.0),),
                  Visibility(
                    visible: _isVisible,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Vehicle No",
                          icon: Icon(Icons.directions_bike)),
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontFamily: "Poppins"),

                      onChanged: (val) {
                        setState(() {
                          vehicleNo = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  // Submit Button

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                              child: Text("Register"),
                              onPressed: () {
                                if(_areFieldsFilled()){
                                  _submitForm(context);
                                  Navigator.pushNamed(context, "/homescreen");
                                }

                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
