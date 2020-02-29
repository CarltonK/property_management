import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    //Date Parsing and Formatting
    var dateRetrieved = data["registerDate"];
    var formatter = new DateFormat('yMMMd');
    String date = formatter.format(dateRetrieved.toDate());
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ExpansionTile(
          title: Text(
            '${data["firstName"]} ${data["lastName"]}',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          ),
          subtitle: Text(
            '${data["apartment_name"]}',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white)),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    ' Member since $date',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(color: Colors.white)),
                  ),
                  RaisedButton(
                      onPressed: () async {
                        var docId = data.documentID;
                        await Firestore.instance
                              .collection("landlords").document(docId).delete();
                      },
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete, color: Colors.green[900]),
                            Text(
                              'Delete',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(color: Colors.green[900], fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: StreamBuilder<QuerySnapshot>(
        initialData: null,
        stream: Firestore.instance.collection("landlords").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.only(top: 20.0),
              children: snapshot.data.documents
                  .map((data) => _buildListItem(context, data))
                  .toList(),
            );
          }
          return Center(
            child: SpinKitFadingCircle(
              size: 150,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
