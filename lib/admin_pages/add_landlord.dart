import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/models/usermodel.dart';

class AddLandlord extends StatefulWidget {
  @override
  _AddLandlordState createState() => _AddLandlordState();
}

class _AddLandlordState extends State<AddLandlord> {
  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  final _formKey = GlobalKey<FormState>();

  final _focuslname = FocusNode();
  final _focusnatid = FocusNode();
  final _focuspaybill = FocusNode();
  final _focusapartment = FocusNode();
  final _focusemail = FocusNode();
  final _focusphone = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _focuslname.dispose();
    _focusemail.dispose();
    _focuspaybill.dispose();
    _focusapartment.dispose();
    _focusphone.dispose();
    _focusnatid.dispose();
  }

  String _firstName,
      _lastName,
      _natId,
      _phone,
      _paybill = '',
      _apartmentName,
      _email;
  int _lordCode;
  User _user;

  void _emailHandler(String value) {
    _email = value.toLowerCase().trim();
    print('Email: $_email');
  }

  void _firstNameHandler(String value) {
    _firstName = value.trim();
    print('First Name: $_firstName');
  }

  void _lastNameHandler(String value) {
    _lastName = value.trim();
    print('Last Name: $_lastName');
  }

  void _nationalIdHandler(String value) {
    _natId = value.trim();
    print('National ID: $_natId');
  }

  void _phoneHandler(String value) {
    _phone = value.trim();
    print('Phone: $_phone');
  }

  void _paybillHandler(String value) {
    _paybill = value.trim();
    print('Paybill: $_paybill');
  }

  void _apartmentHandler(String value) {
    _apartmentName = value.trim();
    print('Apartment Name: $_apartmentName');
  }

  int lordCodeGenerator() {
    var now = DateTime.now();
    _lordCode = now.microsecondsSinceEpoch;
    return _lordCode;
  }

  Widget _registerFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First Name',
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your first name',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.person,
                color: Colors.white,
              )),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'First Name is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focuslname);
          },
          textInputAction: TextInputAction.next,
          onSaved: _firstNameHandler,
        )
      ],
    );
  }

  Widget _registerOtherName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Other Name(s)',
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focuslname,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your other names',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.person,
                color: Colors.white,
              )),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Other Name(s) are required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusemail);
          },
          textInputAction: TextInputAction.next,
          onSaved: _lastNameHandler,
        )
      ],
    );
  }

  Widget _registerEmail() {
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
          autofocus: false,
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focusemail,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your email',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.email,
                color: Colors.white,
              )),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty) {
              return 'Email is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusphone);
          },
          textInputAction: TextInputAction.next,
          onSaved: _emailHandler,
        )
      ],
    );
  }

  Widget _registerPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone',
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focusphone,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your phone number',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.phone,
                color: Colors.white,
              )),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value.isEmpty) {
              return 'Phone is required';
            }
            if (value.length != 10) {
              return 'Phone number should be 10 digits';
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

  Widget _registerID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'National ID',
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focusnatid,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your ID',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.perm_identity,
                color: Colors.white,
              )),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'ID number is required';
            }
            if (value.length < 7 || value.length > 8) {
              return 'ID number should be 7 or 8 digits';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusapartment);
          },
          textInputAction: TextInputAction.next,
          onSaved: _nationalIdHandler,
        )
      ],
    );
  }

  Widget _registerPaybill() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Paybill (Optional)',
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focuspaybill,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your paybill number',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.confirmation_number,
                color: Colors.white,
              )),
          keyboardType: TextInputType.number,
          validator: (value) {
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.done,
          onSaved: _paybillHandler,
        )
      ],
    );
  }

  Widget _registerApartment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Apartment Name',
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focusapartment,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter the apartment name',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.business,
                color: Colors.white,
              )),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Apartment Name is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focuspaybill);
          },
          textInputAction: TextInputAction.next,
          onSaved: _apartmentHandler,
        )
      ],
    );
  }

  Widget _registerBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        fontSize: 20,
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

  API _api = API();

  Future<bool> serverCall() async {
    result = await _api.saveLandlord(_user);
    print('This is the result: $result');

    if (result == 'Your password is weak. Please choose another') {
      callResponse = false;
      return false;
    } else if (result == "The email format entered is invalid") {
      callResponse = false;
      return false;
    } else if (result == "An account with the same email exists") {
      callResponse = false;
      return false;
    } else {
      callResponse = true;
      return true;
    }
  }

  void _submitBtnPressed() {
    //Validate the Form
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Display the Circular Loading Indicator
      setState(() {
        isLoading = false;
      });

      _user = User(
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          natId: _natId,
          phone: _phone,
          apartmentName: _apartmentName,
          paybill: _paybill,
          designation: "Landlord",
          registerDate: DateTime.now().toLocal(),
          lordCode: lordCodeGenerator());

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
                  'The landlord/lady has been successfully added',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[900],
          elevation: 0.0,
          title: Text(
            'Create Landlord',
            style: GoogleFonts.quicksand(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          leading: IconButton(
              icon: Icon(CupertinoIcons.back),
              onPressed: () => Navigator.of(context).pop())),
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
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Personal Details',
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 0.5)),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _registerFirstName(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerOtherName(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerEmail(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerPhone(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerID(),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Text(
                            'Apartment Details',
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 0.5)),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _registerApartment(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerPaybill(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerBtn()
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
