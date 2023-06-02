import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirbhaya/phone.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyOtp extends StatefulWidget {
  final String num;
  final String PersonName;
  MyOtp({required this.num, required this.PersonName});

  @override
  State<MyOtp> createState() => _MyOtpState(num, PersonName);
}

class _MyOtpState extends State<MyOtp> {
  String num;
  String PersonName;
  _MyOtpState(this.num, this.PersonName);
  // final _phoneController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    // Future addusersdetails(int num) async {
    //   await FirebaseFirestore.instance.collection('users').add({
    //     'phone': num,
    //   });
    // }

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";

    return Scaffold(
      extendBodyBehindAppBar: true,
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
              'Enter OTP',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'We need to Verify   before proceeding !',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 35,
            ),
            Pinput(
              length: 6,
              onChanged: (value) {
                code = value;
              },
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,

              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              // onCompleted: (pin) => print(pin),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: MyPhone.verify, smsCode: code);

                    // Sign the user in (or link) with the credential
                    auth.signInWithCredential(credential).then((value) {
                      users.add({'Contact': num, 'Name ': PersonName});
                    });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyPhone(name: "Ashish")),
                        (route) => false);
                  } catch (e) {
                    print('Verification failed');
                  }
                },
                child: Text('Verify OTP'),
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
}
