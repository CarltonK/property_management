import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManagerProf extends StatefulWidget {
  @override
  _ManagerProfState createState() => _ManagerProfState();
}

class _ManagerProfState extends State<ManagerProf> {
  static Map<String, dynamic> data;
  int code;
  final String _collectionUpper = "payments";
  final String _collectionLower = "received";

  // Future<List<DocumentSnapshot>> _getPayments(int code) async {
  //   QuerySnapshot query = await Firestore.instance
  //       .collection(_collectionUpper)
  //       .document(code.toString())
  //       .collection(_collectionLower)
  //       .where("approved", isEqualTo: false)
  //       .orderBy("date", descending: true)
  //       .getDocuments();
  //   return query.documents;
  // }

  static var date = DateTime.now();
  static var formatter = new DateFormat('yMMM');
  String dateFormatted = formatter.format(date);

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    code = data["landlord_code"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Kejani',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
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
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Payment approvals',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection(_collectionUpper)
                                    .document(code.toString())
                                    .collection(_collectionLower)
                                    .where("approved", isEqualTo: false)
                                    .orderBy("date", descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'There are no pending payment requests',
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    );
                                  }
                                  if (snapshot.data == null) {
                                    return Center(
                                      child: Text(
                                        'There are no pending payment requests',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 16,
                                        )),
                                      ),
                                    );
                                  }
                                  if (snapshot.data.documents.length == 0) {
                                    return Center(
                                      child: Text(
                                        'There are no pending payment requests',
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    return ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: snapshot.data.documents
                                          .map((map) => map["mode"] == "bank"
                                              ? Card(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width: 200,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Positioned(
                                                          child: Image.network(
                                                              map["url"]),
                                                          width: 200,
                                                        ),
                                                        Positioned(
                                                          bottom: 10,
                                                          left: 10,
                                                          child: map["approved"] ==
                                                                  false
                                                              ? FlatButton(
                                                                  color: Colors
                                                                      .white,
                                                                  onPressed:
                                                                      () async {
                                                                    //Update payments collection
                                                                    var docId =
                                                                        map.documentID;
                                                                    await Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "payments")
                                                                        .document(code
                                                                            .toString())
                                                                        .collection(
                                                                            "received")
                                                                        .document(
                                                                            docId)
                                                                        .updateData({
                                                                      "approved":
                                                                          true,
                                                                    });

                                                                    showCupertinoModalPopup(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return CupertinoActionSheet(
                                                                            title:
                                                                                Text(
                                                                              'Payment approved',
                                                                              style: GoogleFonts.quicksand(
                                                                                  textStyle: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 20,
                                                                                color: Colors.black,
                                                                              )),
                                                                            ),
                                                                          );
                                                                        });
                                                                  },
                                                                  child: Text(
                                                                    'Approve',
                                                                    style: GoogleFonts.quicksand(
                                                                        textStyle: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ))
                                                              : Text(''),
                                                        ),
                                                        Positioned(
                                                          top: 10,
                                                          left: 10,
                                                          child: Container(
                                                            color: Colors.white,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${map["fullName"]}',
                                                                  style: GoogleFonts.quicksand(
                                                                      textStyle: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Card(
                                                  color:
                                                      Colors.greenAccent[400],
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width: 200,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Positioned(
                                                          bottom: 10,
                                                          left: 10,
                                                          child: map["approved"] ==
                                                                  false
                                                              ? FlatButton(
                                                                  color: Colors
                                                                      .white,
                                                                  onPressed:
                                                                      () async {
                                                                    //Update payments collection
                                                                    var docId =
                                                                        map.documentID;
                                                                    await Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "payments")
                                                                        .document(code
                                                                            .toString())
                                                                        .collection(
                                                                            "received")
                                                                        .document(
                                                                            docId)
                                                                        .updateData({
                                                                      "approved":
                                                                          true,
                                                                    });
                                                                    showCupertinoModalPopup(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return CupertinoActionSheet(
                                                                            title:
                                                                                Text(
                                                                              'Payment approved',
                                                                              style: GoogleFonts.quicksand(
                                                                                  textStyle: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 20,
                                                                                color: Colors.black,
                                                                              )),
                                                                            ),
                                                                          );
                                                                        });
                                                                  },
                                                                  child: Text(
                                                                    'Approve',
                                                                    style: GoogleFonts.quicksand(
                                                                        textStyle: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ))
                                                              : Text(''),
                                                        ),
                                                        Positioned(
                                                          top: 10,
                                                          left: 10,
                                                          child: Container(
                                                            color: Colors.white,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${map["fullName"]}\n${map["mode"]}\n${map["amount"]}',
                                                                  style: GoogleFonts.quicksand(
                                                                      textStyle: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                          .toList(),
                                    );
                                  }
                                  return Center(
                                    child: SpinKitFadingCircle(
                                      size: 150,
                                      color: Colors.white,
                                    ),
                                  );
                                }))
                      ],
                    ),
                  )),
                  Divider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                  Expanded(
                      child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Bookings',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        )
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
}
