import 'dart:async';

import 'package:contact_app_new/Dashboard.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(MaterialApp(
    home: SplashScreen(
    ),
  ));
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  Map<String, double> userLocation;
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ContactListing()));
  }
  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue,
        ),
      ),

      debugShowCheckedModeBanner: true,
    );
  }
}
