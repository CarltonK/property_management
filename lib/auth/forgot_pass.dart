import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/widgets/dialogs/error_dialog.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';
import 'package:property_management/widgets/utilities/sectionHeader.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email;

  final _formKey = GlobalKey<FormState>();

  void _emailHandler(String email) {
    _email = email.trim();
    print('Email: $_email');
  }

  Widget _resetEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: "Email"),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          decoration: InputDecoration(
            errorStyle: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.indigo,
                width: 1.5,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            icon: Icon(
              Icons.email,
              color: Colors.white,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty) {
              return 'Email is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.next,
          onSaved: _emailHandler,
        )
      ],
    );
  }

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  API _api = API();

  Future<bool> serverCall() async {
    result = await _api.resetPass(_email);
    print('This is the result: $result');

    if (result == "Please register first") {
      callResponse = false;
      return false;
    } else if (result == "Invalid Email. Please enter the correct email") {
      callResponse = false;
      return false;
    } else {
      callResponse = true;
      return true;
    }
  }

  void _resetBtnPressed() {
    print('Reset btn pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = false;
      });

      serverCall().catchError((error) {
        print('This is the error $error');
        FocusScope.of(context).unfocus();
        //Disable the circular progress dialog
        setState(() {
          isLoading = true;
        });
        //Show an action sheet with error
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(message: error.toString());
          },
        );
      }).whenComplete(() {
        if (callResponse) {
          FocusScope.of(context).unfocus();
          print('Successful response $result');
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                title: Text(
                  'Your request has been received',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  )),
                ),
                message: Text(
                  'A password reset link has been sent to your email',
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
          //Timed Function
          Timer(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        } else {
          FocusScope.of(context).unfocus();
          print('Failed response: $result');
          //Disable the circular progress dialog
          setState(() {
            isLoading = true;
          });
          //Show an action sheet with result
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(message: result.toString());
            },
          );
        }
      });
    }
  }

  Widget _resetBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
              color: Colors.white,
              onPressed: _resetBtnPressed,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'RESET PASSWORD',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              BackgroundColor(),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Happens to the best of us',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'You will receive a password reset link in your email',
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
                          height: 50,
                        ),
                        _resetEmail(),
                        SizedBox(
                          height: 30,
                        ),
                        _resetBtn(),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        value: SystemUiOverlayStyle.light,
      ),
    );
  }
}
