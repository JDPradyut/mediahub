import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/jdme/jdpage.dart';
import 'package:mediahub/screens/auth/otpScr.dart';
import 'package:mediahub/screens/mainScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediahub/services/auth/gAuth.dart';
import 'package:line_icons/line_icons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _cCode = TextEditingController();
  Authentication authentication = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SafeArea(
              child: ListView(children: [
                Container(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.black],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/logo.png'))),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      "Let's Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                            margin:
                                EdgeInsets.only(top: 30, right: 10, left: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  child: TextField(
                                    autofocus: true,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText: '91',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        prefix: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text('+'),
                                        )),
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    controller: _cCode,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Phone Number',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    controller: _controller,
                                  ),
                                  flex: 3,
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_cCode.text.trim() != '' &&
                                  _controller.text.trim() != '') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OTPScreen(
                                        _cCode.text, _controller.text)));
                              }
                            },
                            child: Text(
                              'GET OTP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Please confirm your country code and enter your phone number.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Divider(color: Colors.grey),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        await authentication.googleSignIn().whenComplete(() {
                          if (FirebaseAuth.instance.currentUser.uid != null) {
                            Fluttertoast.showToast(
                                msg: 'Login Successful',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                timeInSecForIosWeb: 1,
                                fontSize: 16);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()),
                                (route) => false);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Login Failed: Check Network',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                timeInSecForIosWeb: 1,
                                fontSize: 16);
                          }
                        });
                      },
                      icon: Icon(LineIcons.googleLogo),
                      label: Text('Sign in with Google'))
                ]),
                TextButton(
                  child: Text('Continue without Signing In'),
                  onPressed: () {
                    FirebaseAuth.instance
                        .signInAnonymously()
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => JDPage()),
                            (route) => false);
                      }
                    });
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
