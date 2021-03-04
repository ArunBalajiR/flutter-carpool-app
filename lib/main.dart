import 'package:flutter/material.dart';
import 'package:klndrive/HomeScreen/homeScreen.dart';
import 'package:klndrive/MyRequests/myRequestList.dart';
import 'package:klndrive/MyRides/myRides.dart';
import 'package:klndrive/Profile/profile.dart';
import 'package:klndrive/auth/registerUser.dart';
import 'package:klndrive/misc/credits.dart';
import 'package:klndrive/auth/otpPage.dart';
import 'package:klndrive/auth/otpHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var phone = prefs.getString("phone");
  print(phone);
  runApp(MyApp(screen: phone == null ? OtpHome() : HomeScreen()));
}


class MyApp extends StatelessWidget {
  final Widget screen;
  MyApp({this.screen});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KLN Drive',
      //test phase
      home: screen,
      routes: {
        '/otphome' : (context) => OtpHome(),
        '/otppage' : (context) => OtpPage(),
        '/homescreen' : (context) => HomeScreen(),
        '/register'   : (context) => SignUp(),
        '/myrides'    : (context) => MyRides(),
        '/myrequests' : (context) => MyRequestList(),
        '/profile'    : (context) => ProfilePage(),
        '/credits'    : (context) => Credits(),
      },
    );
  }
}
