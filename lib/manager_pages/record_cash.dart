import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecordCash extends StatefulWidget {
  @override
  _RecordCashState createState() => _RecordCashState();
}

class _RecordCashState extends State<RecordCash> {
  String docId;
  String name;
  String rentAmt;

  Color _color = Colors.white;

  int code;

  static var date = DateTime.now();
  static var formatter = new DateFormat('yMMM');
  String dateFormatted = formatter.format(date);

  void _cashPayment() async {

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Processing payment',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  )),
            ),
            message: SpinKitDualRing(
              color: Colors.red,
              size: 50,
            ),
          );
        });

    await Firestore.instance
        .collection("payments")
        .document(code.toString())
        .collection("received")
        .document()
        .setData({
      "fullName": name,
      "mode": "cash",
      "approved": true,
      "uid": docId,
      "date": date,
    });

    await Firestore.instance
        .collection("users")
        .document(docId)
        .collection("payments_history")
        .document(dateFormatted)
        .setData({
      "mode": "cash",
      "approved": true,
      "date": date,
    });

    Navigator.of(context).pop();

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
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

  }


  @override
  Widget build(BuildContext context) {

    code = ModalRoute.of(context).settings.arguments;

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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.green[900],
              ),
              Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("tenants")
                            .where("approved",isEqualTo: true)
                            .where("landlord_code",isEqualTo: code).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'This apartment has no tenants',
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
                                'This apartment has no tenants',
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
                                'This apartment has no tenants',
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
                              children: snapshot.data.documents.map((map) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      color: Colors.green,
                                      width: 3
                                    )
                                  ),
                                  color: _color,
                                  child: ListTile(
                                    isThreeLine: true,
                                    title: Text(
                                      '${map["fullName"]}',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontWeight:
                                              FontWeight.bold)),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${map["email"]}',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ),
                                        Text(
                                          '${map["apartment_name"]}',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                    trailing: Text(
                                      '${map["hseNumber"]}',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold)),
                                    ),
                                    onTap: () {
                                      print(map.documentID);
                                      setState(() {
                                        docId = map.documentID;
                                        name = map["fullName"];
                                        rentAmt = map["rent"];
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (docId == null) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                    title: Text(
                      'Please select a tenant',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          )),
                    ),
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          'CANCEL',
                          style: GoogleFonts.muli(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        )));
              },
            );
          }
          else {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                    message: Text(
                      'This is to confirm payment of KES $rentAmt from $name',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          )),
                    ),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                            _cashPayment();
                          },
                          child: Text(
                            'PROCEED',
                            style: GoogleFonts.muli(
                                textStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ))
                    ],
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'CANCEL',
                          style: GoogleFonts.muli(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        )));
              },
            );
          }
        },
        splashColor: Colors.greenAccent[700],
        child: Center(
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}


