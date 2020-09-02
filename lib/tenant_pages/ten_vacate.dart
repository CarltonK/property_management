import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TenVacate extends StatefulWidget {
  @override
  _TenVacateState createState() => _TenVacateState();
}

class _TenVacateState extends State<TenVacate> {
  final _formKey = GlobalKey<FormState>();
  DateTime _vacateDate;
  int _code;
  String _name, _hse;

  Map<String, dynamic> data;
  String _reason;

  void _confirmReasonHandler(String value) {
    _reason = value.trim();
    print('Reason: $_reason');
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    _code = data["landlord_code"];
    _name = data["fullName"];
    _hse = data["hseNumber"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
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
                  padding: EdgeInsets.only(top: 30),
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Please fill in the form below to vacate the premises',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      letterSpacing: 0.5)),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Please set your exit date',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      letterSpacing: 0.5)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'You are required to give 30 days notice',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5)),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 30),
                          //   child: DatePickerTimeline(
                          //     DateTime.now().add(Duration(days: 30)),
                          //     height: 100,
                          //     selectionColor: Colors.greenAccent[700],
                          //     onDateChange: (date) {
                          //       _vacateDate = date;
                          //       print('$_vacateDate');
                          //     },
                          //     daysCount: 90,
                          //     dateTextStyle: GoogleFonts.quicksand(
                          //         textStyle: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 24,
                          //             fontWeight: FontWeight.bold)),
                          //     monthTextStyle: GoogleFonts.quicksand(
                          //         textStyle: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w500)),
                          //     dayTextStyle: GoogleFonts.quicksand(
                          //         textStyle: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w500)),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          _reasonTextField(),
                          _submitReasonBtn()
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitReasonBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
              color: Colors.white,
              onPressed: _submitBtnPressed,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
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

  Widget _reasonTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        style: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.white, fontSize: 18)),
        decoration: InputDecoration(
          errorStyle: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red)),
          labelText: 'What is the reason behind your exit?',
          labelStyle:
              GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.white)),
        ),
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        maxLines: 3,
        validator: (value) {
          if (value.isEmpty) {
            return 'This field cannot be empty';
          }
          return null;
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus();
        },
        textInputAction: TextInputAction.done,
        onSaved: _confirmReasonHandler,
      ),
    );
  }

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  Future serverCall(Map<String, dynamic> vacateData) async {
    try {
      await Firestore.instance
          .collection("vacations")
          .document()
          .setData(vacateData);
      callResponse = true;
      return true;
    } catch (e) {
      result = e;
      callResponse = false;
      return false;
    }
  }

  void _submitBtnPressed() {
    FocusScope.of(context).unfocus();
    print('Submit btn pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = false;
      });

      if (_vacateDate == null) {
        //Cancel the Circular Dialog
        setState(() {
          isLoading = true;
        });
        //Show an action sheet with error
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
                title: Text(
                  'Please select a date to vacate',
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
                          textStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    )));
          },
        );
      } else if (_code == 0) {
        //Cancel the Circular Dialog
        setState(() {
          isLoading = true;
        });
        //Show an action sheet with error
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
                title: Text(
                  'Please wait for the landlord to approve your application before submitting a request to vacate',
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
                          textStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    )));
          },
        );
      } else {
        //Set the data
        Map<String, dynamic> data = {
          "name": _name,
          "hse": _hse,
          "date": _vacateDate,
          "reason": _reason,
          "landlord_code": _code
        };

        serverCall(data).catchError((error) {
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
            print('Successful response $result');
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                    title: Text(
                      'You request has been received',
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
            //Disable the circular progress dialog
            setState(() {
              isLoading = true;
            });
          } else {
            print('Failed response: $result');
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
                      '$result',
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
                        child: Text('CANCEL',
                            style: GoogleFonts.muli(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ))));
              },
            );
          }
        });
      }
    }
  }
}
