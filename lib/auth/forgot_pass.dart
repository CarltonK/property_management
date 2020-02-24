import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email;

  final _formKey = GlobalKey<FormState>();

  void _emailHandler(String email) {
    _email = email;
    print('Email: $_email');
  }

  Widget _resetEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
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
                  borderSide: BorderSide(color: Colors.indigo, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your email',
              labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(
                color: Colors.white
              )),
              icon: Icon(Icons.email, color: Colors.white,)),
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

  void _resetBtnPressed() {
    print('Reset btn pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  Widget _resetBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: RaisedButton(
        color: Colors.white,
        onPressed: _resetBtnPressed,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Text(
          'RESET PASSWORD',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.green[900],
                  fontSize: 18,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600)),
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
            onPressed: () => Navigator.of(context).pop()),
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
                                  letterSpacing: 0.5)),
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
                                  letterSpacing: 0.5)),
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
