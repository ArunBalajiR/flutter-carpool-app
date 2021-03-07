import 'package:flutter/material.dart';
import 'package:klndrive/HomeScreen/homeScreen.dart';
import 'package:klndrive/HomeScreen/findaRide.dart';
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
  var isLoggedin = prefs.getBool("isLoggedIn");
  print(isLoggedin);
  runApp(MyApp(screen: isLoggedin ? OtpHome() : HomeScreen()));
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
        '/profile'    : (context) => ProfilePage(),
        '/credits'    : (context) => Credits(),
        '/findaride' : (context) => FindaRide(),
      },
    );
  }
}
