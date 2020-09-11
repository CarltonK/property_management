import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Announcement extends StatefulWidget {
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  int code;

  Widget singleAnnouncementCard(String message, String dateFormatted) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 20,
      child: Container(
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    wordSpacing: 1,
                    fontSize: 17,
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '$dateFormatted',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 1,
              )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    code = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Messages',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.green[900]),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("apartments")
                      .document(code.toString())
                      .collection("announcements")
                      .orderBy("sentDate", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print('Snapshot Error: ${snapshot.error.toString()}');
                      return Center(
                        child: Text(
                          'Ooops! You need approval from your landlord before you can view messages',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.data == null) {
                      return Center(
                        child: Text(
                          'Your message box is empty',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        child: Text(
                          'Your message box is empty',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data.documents.map((map) {
                          var date = map["sentDate"];
                          var message = map["message"];
                          var formatter =
                              new DateFormat('y MMM d \'at\' HH:mm');
                          String dateFormatted =
                              formatter.format(date.toDate());

                          return singleAnnouncementCard(message, dateFormatted);
                        }).toList(),
                      );
                    }
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 150.0,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          value: SystemUiOverlayStyle.light),
    );
  }
}
