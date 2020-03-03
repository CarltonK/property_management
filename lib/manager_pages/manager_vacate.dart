import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagerVacate extends StatefulWidget {
  @override
  _ManagerVacateState createState() => _ManagerVacateState();
}

class _ManagerVacateState extends State<ManagerVacate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[900],
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_pin,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text(
            'Kejani',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
          ),
        ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.green[900],
            )
          ],
        ),
      ),
    );
  }
}