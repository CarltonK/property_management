import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerComplaint extends StatefulWidget {
  @override
  _OwnerComplaintState createState() => _OwnerComplaintState();
}

class _OwnerComplaintState extends State<OwnerComplaint> {

  Widget _appBarLayout() {
    return Text(
      'Complaints received',
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22
          )
      ),
    );
  }

  Widget _singleChildComplaint() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Text(
          '101',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.green[900],
                  fontSize: 20
              )
          ),
        ),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Broken door hinge',
              style: GoogleFonts.quicksand(
                  textStyle:
                  TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500)),
            ),
            Text(
              '30 Dec 2019',
              style: GoogleFonts.quicksand(
                  textStyle:
                  TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        title: Text(
          'Wayne Rooney',
          style: GoogleFonts.quicksand(
              textStyle:
              TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)),
        ),
        trailing: Column(
          children: <Widget>[
            Text(
              'Done',
              style: GoogleFonts.quicksand(
                  textStyle:
                  TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)),
            ),
            Icon(Icons.done),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBarLayout(),
                    SizedBox(
                      height: 20,
                    ),
                    _singleChildComplaint(),
                    _singleChildComplaint(),
                    _singleChildComplaint(),
                    _singleChildComplaint(),
                    _singleChildComplaint(),
                    _singleChildComplaint()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
