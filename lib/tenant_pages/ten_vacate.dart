import 'package:date_picker_timeline/date_picker_timeline.dart';
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

  Widget _appBarLayout() {
    //This custom appBar replaces the Flutter App Bar
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Vacate',
            style: GoogleFonts.muli(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  DateTime _pickVacateEarliest() {
    var now = DateTime.now();
    print('Now: $now');
    var timein1Month = now.add(Duration(days: 30));
    print('1 month from now: $timein1Month');
    return timein1Month;
  }

  String _reason;

  void _confirmReasonHandler(String value) {
    _reason = value;
    print('Reason: $_reason');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.indigo[900]
                ),
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
                          _appBarLayout(),
                          SizedBox(
                            height: 10,
                          ),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: DatePickerTimeline(
                              _pickVacateEarliest(),
                              height: 100,
                              onDateChange: (date) {
                                print('$date');
                              },
                              daysCount: 90,
                              dateTextStyle: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              monthTextStyle: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                              dayTextStyle: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
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
      child: RaisedButton(
        color: Colors.white,
        onPressed: _submitBtnPressed,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Text(
          'SUBMIT',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.indigo,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500)),
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

  void _submitBtnPressed() {
    print('Submit btn pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }
}
