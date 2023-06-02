import 'dart:convert';
import 'package:flutter_sms/flutter_sms.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirbhaya/policeform.dart';
import 'package:nirbhaya/users.dart';
import 'package:nirbhaya/volunteer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:telephony/telephony.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

// Our Home Page
class _InputPageState extends State<InputPage> {
  late Future<Volunteers> futureVolunteers;

  @override
  void initState() {
    _getCurrentLocation();
    futureVolunteers = fetchVolunteers();

    super.initState();
  }

  final Telephony telephony = Telephony.instance;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _msgcontroller = TextEditingController();
  final TextEditingController _valuesms = TextEditingController();

  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: "Locations denied");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Locations denied Permanently");
      }
    }
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition!.latitude);
        _getAdressFrom();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAdressFrom() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.locality},${place.postalCode},${place.street}";
      });
    } catch (e) {
      print(e);
    }
  }

  // @override
  // initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _getCurrentLocation();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 2, 25, 58),
      // appBar: AppBar(
      //     backgroundColor: Colors.black,
      //     title: Center(child: Text('NIRBHAYA')),
      //     actions: []),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/imagebg.jpg'), fit: BoxFit.fill)),
        // image: AssetImage('images/imagee.jpg'), fit: BoxFit.c)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('images/handcrop.png')),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              //   child: Text(
              //     "Welcome to Nirbhaya",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),

              // Container(
              //   margin: EdgeInsets.all(20),
              //   height: 100,
              //   width: 300,
              //   decoration: BoxDecoration(),
              //   child: Center(
              //     child: AnimatedTextKit(
              //       animatedTexts: [
              //         TyperAnimatedText(
              //           'WHO ARE YOU ?',
              //           textStyle: TextStyle(
              //               fontSize: 40,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.blue),
              //           speed: const Duration(milliseconds: 150),
              //         ),
              //       ],
              //       repeatForever: false,
              //     ),
              //   ),
              // ),
              // InkWell(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => VolunteerPage()));
              //     },
              //     child: Container(
              //         height: 100,
              //         width: 200,
              //         margin: EdgeInsets.all(10),
              //         child: Center(
              //           child: Text(
              //             'VOLUNTEER',
              //             style: TextStyle(color: Colors.white, fontSize: 20),
              //           ),
              //         ),
              //         decoration: BoxDecoration(
              //           boxShadow: [
              //             BoxShadow(
              //               spreadRadius: 5,
              //               blurRadius: 5,
              //               offset:
              //                   Offset(0, 0), // changes x,y position of shadow
              //             ),
              //           ],
              //           border: Border.all(
              //               color: Color.fromARGB(255, 30, 93, 255), width: 6),
              //           borderRadius: BorderRadius.circular(10),
              //           // color: Color.fromARGB(255, 29, 66, 136)
              //         ))),
              InkWell(
                onTap: () {
                  // sending_SMS("hey", recepients);
                  _sendSMS();
                  print('send successfully');
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    // color: Colors.red[700],
                    image: DecorationImage(
                        image: AssetImage('images/avatar.jpg'),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 10,
                        blurRadius: 10,
                        // changes x,y position of shadow
                      ),
                    ],
                  ),
                  // height: 100,
                  // width: 200,
                  margin: EdgeInsets.all(10),
                  // child: CircleAvatar(
                  //   backgroundImage: AssetImage('images/avatar.jpg'),
                  //   // backgroundColor: Colors.red[800],
                  //   radius: 80,
                  child: Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 80),
                    ),
                  ),
                ),

                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     color: Colors.red),
              ),
              SizedBox(
                height: 40,
                // child: Text(),
              ),
              SizedBox(
                child: Text(
                  "Sign in ",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PolicePage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        margin: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'POLICE OFFICER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 30, 93, 255),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(
                                  0, 0), // changes x,y position of shadow
                            ),
                          ],
                          border: Border.all(color: Colors.black, width: 4),
                          borderRadius: BorderRadius.circular(10),

                          // color: Color.fromARGB(255, 29, 66, 136)
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 20.0),
                              child: Divider(
                                color: Colors.white,
                                height: 36,
                              )),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              child: Divider(
                                color: Colors.white,
                                height: 36,
                              )),
                        ),
                      ]),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VolunteerPage()));
                      },
                      child: Container(
                          child: Container(
                              height: 60,
                              width: double.infinity,
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  'VOLUNTEER',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 30, 93, 255),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 5,
                                    blurRadius: 15,
                                    offset: Offset(
                                        0, 0), // changes x,y position of shadow
                                  ),
                                ],
                                border: Border.all(
                                    // color: Color.fromARGB(255, 30, 93, 255),
                                    width: 4),
                                borderRadius: BorderRadius.circular(10),
                                // color: Color.fromARGB(255, 29, 66, 136)
                              ))),
                    ),
                  ],
                ),
              )
              //   child: Container(
              //     height: 100,
              //     width: 200,
              //     margin: EdgeInsets.all(10),
              //     child: Center(
              //       child: Text(
              //         'POLICE OFFICER',
              //         style: TextStyle(color: Colors.white, fontSize: 20),
              //       ),
              //     ),
              //     decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 30, 93, 255),
              //       boxShadow: [
              //         BoxShadow(
              // //           spreadRadius: 5,
              // //           blurRadius: 5,
              // //           offset: Offset(0, 0), // changes x,y position of shadow
              // //         ),
              // //       ],
              // //       border: Border.all(
              // //           color: Color.fromARGB(255, 29, 66, 136), width: 6),
              // //       borderRadius: BorderRadius.circular(10),
              // //
              // //       // color: Color.fromARGB(255, 29, 66, 136)
              // //     ),
              // //   ),
              // // )
            ],
          ),
        ),
      ),
    );
  }

  List<String> recepients = ["9501049605", "9888199118"];
  // void sending_SMS(String msg, List<String> list_receipents) async {
  //   String send_result =
  //       await sendSMS(message: msg, recipients: list_receipents)
  //           .catchError((err) {
  //     print(err);
  //   });
  //   print(send_result);
  // }
  _sendSMS() async {
    String mes =
        "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}.${_currentAddress}";
    telephony.sendSms(
        to: "9501049605",
        message: "I need help, follow my Current Location " + mes);
    telephony.sendSms(
        to: "895029041",
        message: "I need help, follow my Current Location " + mes);
    telephony.sendSms(
        to: "8557048137",
        message: "I need help, follow my Current Location " + mes);
  }
  // void _sendSMS() async {
  //   List<String> recepients = ["9501049605", "9888199118"];
  //   sendSMS(message: "Hi there", recipients: recepients);
  // }

  // void _sendSMS(String message, List<String> recipents) async {
  //   String _result = await sendSMS(message: message, recipients: recipents)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //   print(_result);
  // }
  //
  // String message = "This is a test message!";
  // List<String> recipents = ["9501049605", "9888199118"];

  Future<Volunteers> fetchVolunteers() async {
    final response =
        await http.get(Uri.parse('http://20.204.120.182:8082/api/Volunteers'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Volunteers.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class Volunteers {
  final String name;
  final int id;
  final String mobileNumber;
  final String longitude;
  final String latitude;

  const Volunteers(
      {required this.name,
      required this.id,
      required this.mobileNumber,
      required this.longitude,
      required this.latitude});

  factory Volunteers.fromJson(Map<String, dynamic> json) {
    return Volunteers(
      name: json['name'],
      id: json['id'],
      mobileNumber: json['mobileNumber'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}
