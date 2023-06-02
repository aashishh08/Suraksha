import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nirbhaya/login.dart';

class splashScreen extends StatefulWidget {
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InputPage(),
          ));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(image: AssetImage('images/title.jpeg'))),
    ));
  }
}
