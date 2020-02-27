import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerSettings extends StatelessWidget {

  Widget _appBarLayout() {
    return Text(
      'Settings',
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22
          )
      ),
    );
  }

  static Map<String, dynamic> data;
  int code;

  Widget _ownerCode() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: Colors.white54,
              width: 1.2
          )
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.green[800],
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Code: ',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                      )
                  ),
                ),
                Text(
                  '${data["landlord_code"]}',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: .5,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'This code identifies you to your tenants\n'
                  'Present it to them.',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    print('Settings Page Data: $data');

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green[900]
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _appBarLayout(),
                  SizedBox(
                    height: 20,
                  ),
                  _ownerCode()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
