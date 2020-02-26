import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddComplaint extends StatefulWidget {
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {

  final _formKey = GlobalKey<FormState>();
  final _focusmessage = FocusNode();
  String _hse, _message;
  String fname;
  String lname;
  int code;

  void _hseHandler(String value) {
    _hse = value;
    print('House Number: $_hse');
  }

  void _msgHandler(String value) {
    _message = value;
    print('Message: $_message');
  }

  Widget _tenanthseNum() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'House Number',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: .2,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.white
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your house number',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white
                  )
              ),),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'House Number is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusmessage);
          },
          textInputAction: TextInputAction.next,
          onSaved: _hseHandler,
        )
      ],
    );
  }

  Widget _tenantMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Message',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: .2,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.white
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white
                  ),
                borderRadius: BorderRadius.circular(10)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10)),
              labelText: 'What is the issue you are facing?',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white
                  )
              ),),
          keyboardType: TextInputType.text,
          focusNode: _focusmessage,
          maxLines: 3,
          validator: (value) {
            if (value.isEmpty) {
              return 'Message is required';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
          onSaved: _msgHandler,
        )
      ],
    );
  }

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  Future<bool> _postComplaint(Map<String, dynamic> entryData) async {
    //Relevant collections
    final String _collectionUser = 'users';
    final String _collectionComplaints = "complaints";
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    try {
      //Update the user collection first
      await _fireStore
          .collection(_collectionUser)
          .document(data["uid"])
          .collection("complaints_history")
          .document()
          .setData(entryData);
      //Add data to the complaints collection
      await _fireStore
          .collection(_collectionComplaints)
          .document()
          .setData(entryData);
      callResponse = true;
      return true;
    }
    catch (e) {
      print('This is the error: $e');
      callResponse = false;
      return false;
    }
  }

  void _submitPressed() {
    print('Submit button pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = false;
      });

      Map<String, dynamic> newData = {
        "fixed": false,
        "hse": _hse,
        "title": _message,
        "landlord_code": data["landlord_code"],
        "tenant": "${data["firstName"]} ${data["lastName"]}",
        "date": DateTime.now().toLocal().toIso8601String(),
      };

      _postComplaint(newData)
          .whenComplete(() {
        if (callResponse == true) {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                  title: Text(
                    'Your complaint has been posted',
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
                        style: GoogleFonts.quicksand(
                            textStyle:
                            TextStyle(color: Colors.red, fontSize: 25)),
                      ))
              );
            },
          );
          //Disable the circular progress dialog
          setState(() {
            isLoading = true;
          });
        }
        else {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                  title: Text(
                    'Your complaint could not be posted. Try again later',
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
                        style: GoogleFonts.quicksand(
                            textStyle:
                            TextStyle(color: Colors.red, fontSize: 25)),
                      ))
              );
            },
          );
          //Disable the circular progress dialog
          setState(() {
            isLoading = true;
          });
        }
      });

    }
  }

  Widget _submitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
        color: Colors.white,
        onPressed: _submitPressed,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Text(
          'SUBMIT',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.green[900],
                  fontSize: 18,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold)),
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          strokeWidth: 3,
        ),
      ),
    );
  }
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print('Add Complaint Page Data: $data');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
      ),
      backgroundColor: Colors.green[900],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
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
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Hello',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  letterSpacing: 0.5)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Please fill in the form below to submit a complaint',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  letterSpacing: 0.5)),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        _tenanthseNum(),
                        SizedBox(
                          height: 20,
                        ),
                        _tenantMessage(),
                        SizedBox(
                          height: 10,
                        ),
                        _submitBtn()
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
