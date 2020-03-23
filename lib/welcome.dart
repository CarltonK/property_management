import 'package:avatar_glow/avatar_glow.dart';
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
  String _userId;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      await prefs.setBool('seen', true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    new Timer(new Duration(milliseconds: 1), () {
      checkFirstSeen();
    });
    _controller = AnimationController(
      vsync: this,
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
                child: Material(
                  elevation: 10,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: FlutterLogo(
                      size: 50,
                    ),
                    radius: 50,
                  ),
                ),
              ),
              delay: delayedAmount + 1000,
            ),
            DelayedAnimation(
              child: Text(
                'Hi There',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold)),
              ),
              delay: delayedAmount + 2000,
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
              delay: delayedAmount + 3000,
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
              delay: delayedAmount + 4000,
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
              delay: delayedAmount + 5000,
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
              delay: delayedAmount + 6000,
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
