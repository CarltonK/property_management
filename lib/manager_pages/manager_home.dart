import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/breakdown_widget.dart';
import 'package:property_management/widgets/tenant_popup.dart';

class ManagerHome extends StatefulWidget {
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  static Map<String, dynamic> data;
  int code;
  String apartment_name;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<List<DocumentSnapshot>> _getFloors(int code) async {
    final String _collectionUpper = "apartments";
    final String _collectionLower = "floors";

    QuerySnapshot query = await Firestore.instance
        .collection(_collectionUpper)
        .document(code.toString())
        .collection(_collectionLower)
        .orderBy("floorNumber")
        .getDocuments();
    return query.documents;
  }

  @override
  void initState() {
    super.initState();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');

        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text(
                  '${message["notification"]["title"]}',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  )),
                ),
                content: Text(
                  '${message["notification"]["body"]}',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.muli(
                            textStyle: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                      ))
                ],
              );
            });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        Navigator.of(context).pushNamed('/manager-prof', arguments: data);

//        showCupertinoModalPopup(
//            context: context,
//            builder: (BuildContext context) {
//              return CupertinoAlertDialog(
//                title: Text(
//                  '${message["notification"]["title"]}',
//                  style: GoogleFonts.quicksand(
//                      textStyle: TextStyle(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 20,
//                      )),
//                ),
//                content: Text(
//                  '${message["notification"]["body"]}',
//                  style: GoogleFonts.quicksand(
//                      textStyle: TextStyle(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 16,
//                      )),
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                      onPressed: () => Navigator.of(context).pop(),
//                      child: Text(
//                        'CANCEL',
//                        style: GoogleFonts.muli(
//                            textStyle: TextStyle(
//                              color: Colors.red,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 20,
//                            )),
//                      ))
//                ],
//              );
//            }
//        );
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        Navigator.of(context).pushNamed('/manager-prof', arguments: data);

//        showCupertinoModalPopup(
//            context: context,
//            builder: (BuildContext context) {
//              return CupertinoAlertDialog(
//                title: Text(
//                  '${message["notification"]["title"]}',
//                  style: GoogleFonts.quicksand(
//                      textStyle: TextStyle(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 20,
//                      )),
//                ),
//                content: Text(
//                  '${message["notification"]["body"]}',
//                  style: GoogleFonts.quicksand(
//                      textStyle: TextStyle(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 16,
//                      )),
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                      onPressed: () => Navigator.of(context).pop(),
//                      child: Text(
//                        'CANCEL',
//                        style: GoogleFonts.muli(
//                            textStyle: TextStyle(
//                              color: Colors.red,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 20,
//                            )),
//                      ))
//                ],
//              );
//            }
//        );
      },
    );
  }

  bool isLoading = true;

  String message;
  final _formKey = GlobalKey<FormState>();

  void _messageHandler(String value) {
    message = value.trim();
    print('Message: $message');
  }

  Widget _addMessage(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black, fontSize: 18)),
      decoration: InputDecoration(
        errorStyle: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black),
        ),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'A message is required';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.done,
      onSaved: _messageHandler,
    );
  }

  Future serverCall() async {
    await Firestore.instance
        .collection("apartments")
        .document(code.toString())
        .collection("announcements")
        .document()
        .setData({
      "message": message,
      "sentDate": DateTime.now(),
      "code": code.toString(),
    });
  }

  void _completeBtnPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = false;
      });

      serverCall().catchError((error) {
        print('This is the error $error');
        //Disable the circular progress dialog
        setState(() {
          isLoading = true;
        });
        //Show an action sheet with error
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
                title: Text(
                  '$error',
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
      }).whenComplete(() {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(
                'Your message has been sent',
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
        //Disable the circular progress dialog
        setState(() {
          isLoading = true;
        });
        Timer(Duration(seconds: 2), () => Navigator.of(context).pop());
        Timer(Duration(seconds: 3), () => Navigator.of(context).pop());
      });
    }
  }

  void _announceBtnPressed() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Send a message to all tenants',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.greenAccent[700], width: 1.5)),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _addMessage(context),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18)),
                ),
                color: Colors.red,
              ),
              isLoading
                  ? FlatButton(
                      onPressed: _completeBtnPressed,
                      child: Text(
                        'SEND',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18)),
                      ),
                      color: Colors.green,
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    code = data["landlord_code"];
    apartment_name = data["apartment_name"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/manager-prof', arguments: data);
          },
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
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tenants',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: FutureBuilder<List<DocumentSnapshot>>(
                          future: _getFloors(code),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasError) {
                              print(
                                  'Snapshot Error: ${snapshot.error.toString()}');
                              return Center(
                                  child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'There is an error ${snapshot.error.toString()}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                                  )
                                ],
                              ));
                            } else {
                              switch (snapshot.connectionState) {
                                case ConnectionState.done:
                                  if (snapshot.data.length == 0) {
                                    return Center(
                                      child: Text(
                                        'This apartment has no tenants',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 28,
                                                color: Colors.white)),
                                      ),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: Breakdown(
                                        snapshot: snapshot.data,
                                        code: code,
                                      )),
                                    ],
                                  );
                                  break;
                                case ConnectionState.waiting:
                                  return Center(
                                    child: SpinKitFadingCircle(
                                      size: 150,
                                      color: Colors.white,
                                    ),
                                  );
                                  break;
                                case ConnectionState.active:
                                  break;
                                case ConnectionState.none:
                                  break;
                              }
                              return Center(
                                child: SpinKitFadingCircle(
                                  size: 150,
                                  color: Colors.white,
                                ),
                              );
                            }
                          }),
                    ),
                  )
                ],
              ),
            ),
            TenantPopup(
              apartment_name: data["apartment_name"],
              code: data["landlord_code"],
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MaterialButton(
            color: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            splashColor: Colors.greenAccent[700],
            onPressed: () {
              Navigator.of(context).pushNamed('/record-cash', arguments: code);
            },
            child: Text(
              'Cash payment',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
            ),
          ),
          MaterialButton(
            color: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            splashColor: Colors.greenAccent[700],
            onPressed: _announceBtnPressed,
            child: Text(
              'Announcements',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
            ),
          )
        ],
      ),
    );
  }
}
