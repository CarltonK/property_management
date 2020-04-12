import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  String _phone, _natId;
  double opacity = 1.0;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  letterSpacing: .2,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autofocus: false,
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.black, fontSize: 18)),
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.black),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your phone number',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.black)),
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
        )
      ],
    );
  }

  Widget _registerID(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Identification',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.black,
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
              textStyle: TextStyle(color: Colors.black, fontSize: 18)),
          focusNode: _focusnatid,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.black),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your ID',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.black)),
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
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              child: Text(
                'SUBMIT',
                style: GoogleFonts.muli(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ))
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
            child: Text(
              'SKIP',
              style: GoogleFonts.muli(
                  textStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            )),
        message: Column(
          children: <Widget>[
            Text(
              'Complete your profile',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20)),
            ),
            SizedBox(
              height: 20,
            ),
            _registerPhone(context),
            SizedBox(
              height: 20,
            ),
            _registerID(context),
          ],
        ),
      ),
    );
  }
}
