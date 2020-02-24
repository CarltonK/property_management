import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
        title: Text(
          'PROFILE',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: 24)),
        ),
      ),
      backgroundColor: Colors.white,
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Hero(
                      tag: 'tenant',
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Jon Snow',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25)),
                  ),
                  Text(
                    'Tenant since July 2019',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 18)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green[500], width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20)),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.location_city,
                                  size: 100,
                                ),
                                Text(
                                  'BUILDING',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[400],
                                          fontSize: 15)),
                                ),
                                Text(
                                  'Lala Salama',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green[500], width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20)),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.book_solid,
                                  size: 100,
                                ),
                                Text(
                                  'CONTRACT END',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[400],
                                          fontSize: 15)),
                                ),
                                Text(
                                  'July 2020',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
