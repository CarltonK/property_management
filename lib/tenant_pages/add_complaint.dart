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
  String _message;
  int code;

  void _msgHandler(String value) {
    _message = value.trim();
    print('Message: $_message');
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
          autofocus: false,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          decoration: InputDecoration(
            errorStyle: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'What is the issue you are facing?',
            labelStyle: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          keyboardType: TextInputType.text,
          focusNode: _focusmessage,
          maxLines: 3,
          validator: (value) {
            if (value.isEmpty) {
              return 'Message is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
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
    final String _collectionComplaints = "complaints";
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    try {
      //Add data to the complaints collection
      await _fireStore
          .collection(_collectionComplaints)
          .document()
          .setData(entryData);
      callResponse = true;
      return true;
    } catch (e) {
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

      if (code == 0) {
        setState(() {
          isLoading = true;
        });
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(
                'Your complaint could not be posted',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              message: Text(
                'Please wait for the landlord to approve you',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      } else {
        Map<String, dynamic> newData = {
          "fixed": false,
          "hse": data["hseNumber"],
          "uid": data["uid"],
          "title": _message,
          "landlord_code": data["landlord_code"],
          "tenant": "${data["fullName"]}",
          "date": Timestamp.now(),
        };
        _postComplaint(newData).catchError((error) {
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
                    ),
                  ),
                ),
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).whenComplete(() {
          setState(() {
            isLoading = true;
          });
          if (callResponse == true) {
            FocusScope.of(context).unfocus();
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
                      ),
                    ),
                  ),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CANCEL',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
            //Timed Function
            Timer(Duration(seconds: 1), () {
              Navigator.of(context).pop();
            });
            Timer(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
          }
        });
      }
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'SUBMIT',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.green[900],
                    fontSize: 18,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
  void dispose() {
    super.dispose();
    _focusmessage.dispose();
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      title: Text(
        'Complaint',
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    // print('Add Complaint Page Data: $data');
    code = data["landlord_code"];

    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.green[900],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.green[900]),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Please fill in the form below to submit a complaint',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
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
