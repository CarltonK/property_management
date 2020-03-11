import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/models/usermodel.dart';

class TenantProfile extends StatefulWidget {
  @override
  _TenantProfileState createState() => _TenantProfileState();
}

class _TenantProfileState extends State<TenantProfile> {
  String _phone, _natId;
  final _formKey = GlobalKey<FormState>();

  final _focusnatid = FocusNode();

  void _natIdHandler(String value) {
    _natId = value.trim();
    print('National ID: $_natId');
  }

  void _phoneHandler(String value) {
    _phone = value.trim();
    print('Phone: $_phone');
  }

  Widget _registerPhone(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black, fontSize: 18)),
      decoration: InputDecoration(
          errorStyle: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.black),
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5)),
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          labelText: 'Phone Number',
          labelStyle:
              GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.black)),
          icon: Icon(
            Icons.phone,
            color: Colors.black,
          )),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value.isEmpty) {
          return 'Phone is required';
        }
        if (value.length != 10) {
          return 'Phone number should be 10 digits';
        }
        if (!value.startsWith("07")) {
          return 'Phone number should start with "O7"';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_focusnatid);
      },
      textInputAction: TextInputAction.next,
      onSaved: _phoneHandler,
    );
  }

  Widget _registerID(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black, fontSize: 18)),
      focusNode: _focusnatid,
      decoration: InputDecoration(
          errorStyle: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.black),
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5)),
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          labelText: 'ID Number',
          labelStyle:
              GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.black)),
          icon: Icon(
            Icons.perm_identity,
            color: Colors.black,
          )),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'ID number is required';
        }
        if (value.length < 7 || value.length > 8) {
          return 'ID number should be 8 digits';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.done,
      onSaved: _natIdHandler,
    );
  }

  bool isProfilePending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;
    print('Data received in profile page $user');

    //Date Parsing and Formatting
//    print('${user["registerDate"].runtimeType}');
    var dateTime = user["registerDate"].microsecondsSinceEpoch;
//    print('$dateTime');
    var parsedDate = new DateTime.fromMicrosecondsSinceEpoch(dateTime);
    var formatter = new DateFormat('yMMMd');
    String dateFormatted = formatter.format(parsedDate);

    //Prompt user to update their details

    if (user["phone"] == null) {
      isProfilePending = true;
    }
    print(isProfilePending);

    bool isLoading = true;
    dynamic result;
    bool callResponse = false;
    User _user;
    API _api = API();

    Future<bool> serverCall() async {
      result = await _api.completeProfile(_user, user["uid"]);
      print('This is the result: $result');

      if (result == null) {
        callResponse = false;
        return false;
      }
      callResponse = true;
      return true;
    }

    void _completeBtnPressed() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        _user = User(
          phone: _phone,
          natId: _natId
        );

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
          if (callResponse) {
            //print('Successful response ${result}');
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(
                    'Your profile has been updated',
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
          }
          else {
            //print('Failed response: ${result}');
            //Disable the circular progress dialog
            setState(() {
              isLoading = true;
            });
            //Show an action sheet with result
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                    title: Text(
                      'We have updated your profile',
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
        });

      }
    }

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
        actions: <Widget>[
          isProfilePending
              ? IconButton(
                  icon: Icon(
                    Icons.person_add,
                    size: 30,
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Complete your profile',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18)),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                    color: Colors.greenAccent[700],
                                    width: 1.5)),
                            content: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _registerPhone(context),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _registerID(context)
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'SKIP',
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
                                        'COMPLETE',
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
                  })
              : Text(''),
        ],
      ),
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('I want to set my profile picture');
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Hero(
                        tag: 'tenant',
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 100,
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${user["fullName"]}',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25)),
                  ),
                  Text(
                    'Tenant since $dateFormatted',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 18)),
                  ),
//                  Container(
//                    padding: EdgeInsets.symmetric(vertical: 20),
//                    height: MediaQuery.of(context).size.height * 0.35,
//                    width: MediaQuery.of(context).size.width,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        Card(
//                          shape: RoundedRectangleBorder(
//                            side: BorderSide(
//                                color: Colors.green[500], width: 1.5),
//                            borderRadius: BorderRadius.circular(20),
//                          ),
//                          elevation: 5,
//                          child: Container(
//                            decoration: BoxDecoration(
//                                color: Colors.grey[100],
//                                borderRadius: BorderRadius.circular(20)),
//                            width: MediaQuery.of(context).size.width * 0.4,
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(
//                                  Icons.location_city,
//                                  size: 100,
//                                ),
//                                Text(
//                                  'BUILDING',
//                                  style: GoogleFonts.quicksand(
//                                      textStyle: TextStyle(
//                                          fontWeight: FontWeight.bold,
//                                          color: Colors.indigo[400],
//                                          fontSize: 15)),
//                                ),
//                                Text(
//                                  'Lala Salama',
//                                  style: GoogleFonts.quicksand(
//                                      textStyle: TextStyle(
//                                          fontWeight: FontWeight.w400,
//                                          fontSize: 20)),
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
//                        Card(
//                          shape: RoundedRectangleBorder(
//                            side: BorderSide(
//                                color: Colors.green[500], width: 1.5),
//                            borderRadius: BorderRadius.circular(20),
//                          ),
//                          elevation: 5,
//                          child: Container(
//                            decoration: BoxDecoration(
//                                color: Colors.grey[100],
//                                borderRadius: BorderRadius.circular(20)),
//                            width: MediaQuery.of(context).size.width * 0.4,
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(
//                                  CupertinoIcons.book_solid,
//                                  size: 100,
//                                ),
//                                Text(
//                                  'CONTRACT END',
//                                  style: GoogleFonts.quicksand(
//                                      textStyle: TextStyle(
//                                          fontWeight: FontWeight.bold,
//                                          color: Colors.indigo[400],
//                                          fontSize: 15)),
//                                ),
//                                Text(
//                                  'July 2020',
//                                  style: GoogleFonts.quicksand(
//                                      textStyle: TextStyle(
//                                          fontWeight: FontWeight.w400,
//                                          fontSize: 20)),
//                                )
//                              ],
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  )
                ],
              ),
            ),
//            Positioned(
//              top: 70,
//              bottom: 70,
//              left: 20,
//              right: 20,
//              child: AnimatedOpacity(
//                opacity: isProfilePending ? 1 : 0,
//                duration: Duration(milliseconds: 500),
//                child: Card(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(16),
//                    side: BorderSide(
//                      color: Colors.greenAccent[700],
//                      width: 2
//                    )
//                  ),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(16),
//                    ),
//                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//                    height: MediaQuery.of(context).size.height,
//                    width: MediaQuery.of(context).size.width,
//                    child: Column(
//                      children: <Widget>[
//                        Text(
//                          'Complete your profile',
//                          style: GoogleFonts.quicksand(
//                              textStyle: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.black,
//                                  fontSize: 20)),
//                        ),
//                        SizedBox(height: 20,),
//                        _registerPhone(context),
//                        SizedBox(height: 20,),
//                        _registerID(context),
//                        Expanded(
//                            child: Container(
//                              child: Center(
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                  children: <Widget>[
//                                    RaisedButton(
//                                      padding: EdgeInsets.all(12),
//                                      color: Colors.green[900],
//                                        child: Text(
//                                          'SKIP',
//                                          style: GoogleFonts.quicksand(
//                                              textStyle: TextStyle(
//                                                  fontWeight: FontWeight.bold,
//                                                  color: Colors.white,
//                                                  fontSize: 18)),
//                                        ),
//                                        onPressed: _skipBtnPressed
//                                    ),
//                                    RaisedButton(
//                                        padding: EdgeInsets.all(12),
//                                        color: Colors.green[900],
//                                        child: Text(
//                                          'COMPLETE',
//                                          style: GoogleFonts.quicksand(
//                                              textStyle: TextStyle(
//                                                  fontWeight: FontWeight.bold,
//                                                  color: Colors.white,
//                                                  fontSize: 18)),
//                                        ),
//                                        onPressed: () {
//
//                                        })
//                                  ],
//                                ),
//                              ),
//                            ))
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
