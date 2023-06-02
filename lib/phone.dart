import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nirbhaya/verification.dart';
import 'package:nirbhaya/volunteer.dart';
import 'package:http/http.dart' as http;

class MyPhone extends StatefulWidget {
  final String name;
  MyPhone({required this.name});
  static String verify = "";
  @override
  State<MyPhone> createState() => _MyPhoneState(name);
}

class _MyPhoneState extends State<MyPhone> {
  String name;
  _MyPhoneState(this.name);
  TextEditingController countryCode = TextEditingController();
  TextEditingController PhoneNum = TextEditingController();

  late Future<Volunteers> futureVolunteers;

  var phone = "";
  @override
  void initState() {
    // TODO: implement initState
    futureVolunteers = fetchVolunteers();
    countryCode.text = "+91";
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/title.jpeg', width: 250, height: 150),
            SizedBox(
              height: 30,
            ),
            Text(
              'Phone Verification',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'We need to register your Phone Number before proceeding !',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: countryCode,
                    decoration: InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "|",
                  style: TextStyle(fontSize: 33, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    controller: PhoneNum,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      phone = value;
                    },
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Phone"),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '${countryCode.text + phone}',
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      MyPhone.verify = verificationId;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyOtp(num: phone, PersonName: name)));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                child: Text('Get OTP'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 29, 66, 136),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            )
          ],
        )),
      ),
    );
  }

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
