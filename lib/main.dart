import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:nirbhaya/confirmation.dart';
import 'package:nirbhaya/login.dart';
import 'package:nirbhaya/maps.dart';
import 'package:nirbhaya/phone.dart';
import 'package:nirbhaya/policeform.dart';
import 'package:nirbhaya/splashscreen.dart';
import 'package:nirbhaya/users.dart';
import 'package:nirbhaya/volunteer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primaryColor: Color(0xFF0A0E21),
          // scaffoldBackgroundColor: Colors.white,
          // textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
          // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
          ),
      home: InputPage(),
    );
  }
}
