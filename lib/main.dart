import 'package:flutter/material.dart';
import 'package:klndrive/HomeScreen/homeScreen.dart';
import 'package:klndrive/MyRequests/myRequestList.dart';
import 'package:klndrive/MyRides/myRides.dart';
import 'package:klndrive/Profile/profile.dart';
import 'package:klndrive/SplashScreen/splashScreen.dart';
import 'package:klndrive/auth/registerUser.dart';
import 'package:klndrive/misc/credits.dart';
import 'package:klndrive/auth/otpPage.dart';
import 'package:klndrive/auth/otpHome.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MecDrive',
      //test phase
      home: OtpHome(),
      routes: {
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
