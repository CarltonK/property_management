import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:property_management/widgets/delayed_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Welcome extends StatefulWidget {
  // Welcome({this.api});

  // final API api;

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      checkLoginStatus().then((value) {
        if (value == null) {
          Navigator.of(context).pushNamed('/login');
        } else {
          getUserBase(value);
        }
      });
    } else {
      await prefs.setBool('seen', true);
    }
  }

  Future checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    return uid;
  }

  Future getUserBase(String uid) async {
    //This is the name of the collection we will be reading
    final String _collection = 'users';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    var document = _fireStore.collection(_collection).document(uid);
    var returnDoc = document.get();
    //Show the return value - A DocumentSnapshot;
    //print('This is the return ${returnDoc}');
    returnDoc.then((value) async {
      //Extract values
      String userdesignation = value.data["designation"];
      //Return the data for user
      Map<String, dynamic> userData = value.data;
      //Add the uid to the Map
      userData["uid"] = uid;

      // //Try save credentials using shared preferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('uid', uid);

      //Show different home pages based on designation
      //Tenant Page
      if (userdesignation == "Tenant") {
        //Timed Function
        Timer(Duration(milliseconds: 50), () {
          Navigator.of(context)
              .popAndPushNamed('/tenant-home', arguments: userData);
        });
      }
      //Admin Page
      else if (userdesignation == "Admin") {
        //Timed Function
        Timer(Duration(milliseconds: 50), () {
          Navigator.of(context).popAndPushNamed('/admin', arguments: userData);
        });
      }
      //Manager page
      else if (userdesignation == "Manager") {
        //Timed Function
        Timer(Duration(milliseconds: 50), () {
          Navigator.of(context)
              .popAndPushNamed('/manager', arguments: userData);
        });
      }
      //Landlord Page
      else if (userdesignation == "Landlord") {
        //Timed Function
        Timer(Duration(milliseconds: 50), () {
          Navigator.of(context)
              .popAndPushNamed('/owner_home', arguments: userData);
        });
      } else {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              message: Text(
                'This account is not registered',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                )),
              ),
            );
          },
        );
      }
    }).catchError((error) {
      //Pop welcome dialog
      //Navigator.of(context).pop();

      Navigator.of(context).pushNamed('/login');
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            message: Text(
              'You have been gone for too long. Please login again',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              )),
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    new Timer(new Duration(milliseconds: 5000), () {
      checkFirstSeen();
    });
    _controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();

    // widget.api.getCurrentUser().then((user) {
    //   setState(() {
    //     if (user != null) {
    //       _userId = user?.uid;
    //     }
    //     authStatus =
    //         user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
    //   });
    // });
  }

  // void loginCallback() {
  //   widget.api.getCurrentUser().then((user) {
  //     setState(() {
  //       _userId = user.uid.toString();
  //     });
  //   });
  //   setState(() {
  //     authStatus = AuthStatus.LOGGED_IN;
  //   });
  // }

  // void logoutCallback() {
  //   setState(() {
  //     authStatus = AuthStatus.NOT_LOGGED_IN;
  //     _userId = "";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DelayedAnimation(
              child: AvatarGlow(
                endRadius: 90,
                duration: Duration(seconds: 2),
                glowColor: Colors.white,
                repeat: true,
                repeatPauseDuration: Duration(seconds: 2),
                startDelay: Duration(seconds: 1),
                child: Image.asset(
                  'assets/launcher/logo.png',
                ),
              ),
              delay: delayedAmount + 500,
            ),
            DelayedAnimation(
              child: Text(
                'Hi There',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              delay: delayedAmount + 1500,
            ),
            DelayedAnimation(
              child: Text(
                'Karibu Kejani',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold)),
              ),
              delay: delayedAmount + 2000,
            ),
            SizedBox(
              height: 30.0,
            ),
            DelayedAnimation(
              child: Text(
                'Your new housing solution',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
              delay: delayedAmount + 2500,
            ),
            SizedBox(
              height: 30.0,
            ),
            DelayedAnimation(
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTap: () => Navigator.of(context).pushNamed('/register'),
                child: Transform.scale(
                  scale: _scale,
                  child: _animatedButtonUI,
                ),
              ),
              delay: delayedAmount + 3000,
            ),
            SizedBox(
              height: 10.0,
            ),
            DelayedAnimation(
              child: FlatButton(
                padding: EdgeInsets.all(16),
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
                child: Text(
                  "I Already have An Account",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              delay: delayedAmount + 4000,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'LET\'S GET STARTED',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
