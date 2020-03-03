import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/models/usermodel.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  User _user;
  final _formKey = GlobalKey<FormState>();

  //Save Registration Date
  var now = DateTime.now();

  final _focuslname = FocusNode();
  final _focusemail = FocusNode();
  final _focusphone = FocusNode();
  final _focusnatid = FocusNode();
  final _focuspass = FocusNode();
  final _focuscpass = FocusNode();

  String _fname, _lname, _email, _phone, _natId, _pass, _cpass;

  final TextEditingController _passwording = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  void _emailHandler(String email) {
    _email = email.trim();
    print('Email: $_email');
  }

  void _phoneHandler(String phone) {
    _phone = phone.trim();
    print('Phone: $_phone');
  }

  void _firstNameHandler(String name1) {
    _fname = name1.trim();
    print('First Name: $_fname');
  }

  @override
  void dispose() {
    super.dispose();
    //Dispose the FocusNodes
    _focuslname.dispose();
    _focusemail.dispose();
    _focusphone.dispose();
    _focusnatid.dispose();
    _focuspass.dispose();
    _focuscpass.dispose();
    //Dispose the TextEditingControllers
    _passwording.dispose();
    _confirmPass.dispose();
  }

  void _lastNameHandler(String name2) {
    _lname = name2.trim();
    print('Last Name: $_lname');
  }

  void _natIdHandler(String id) {
    _natId = id.trim();
    print('National ID: $_natId');
  }

  void _passHandler(String password) {
    _pass = password.trim();
    print('Password(1): $_pass');
  }

  void _confirmPassHandler(String confirmation) {
    _cpass = confirmation.trim();
    print('Password(2): $_cpass');
  }

  Widget _signInWidget() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
      onTap: () {
        print('I want to sign in');
        Navigator.of(context).pushNamed('/login');
      },
      splashColor: Colors.grey,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
        child: Center(
          child: Text(
            'SIGN IN',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.green[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
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
          height: 5,
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
              return 'Name is required';
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
          height: 5,
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
              return 'Name is required';
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
          height: 5,
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
          height: 5,
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

  Widget _registerID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Identification',
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
              return 'ID number should be 8 digits';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focuspass);
          },
          textInputAction: TextInputAction.next,
          onSaved: _natIdHandler,
        )
      ],
    );
  }

  Widget _registerPassword1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          controller: _passwording,
          focusNode: _focuspass,
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
              labelText: 'Please enter your password',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.vpn_key,
                color: Colors.white,
              )),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password should be 6 or more characters';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focuscpass);
          },
          textInputAction: TextInputAction.next,
          onSaved: _passHandler,
        )
      ],
    );
  }

  String apartmentName;
  void _showListPopup() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CupertinoActionSheet(
                title: Text(
                  'Apartments',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(fontSize: 30, color: Colors.black)),
                ),
                actions: <Widget>[
                  Container(
                    height: 250,
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("apartments")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
                              children: snapshot.data.documents
                                  .map((data) => Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            print(
                                                'You have selected: ${data["apartment_name"]}');
                                            apartmentName =
                                                data["apartment_name"];
                                          },
                                          child: ListTile(
                                            title: Text(
                                              data["apartment_name"],
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            );
                          }
                          return LinearProgressIndicator();
                        }),
                  )
                ],
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
                    ))),
          );
        });
  }

  //Group value
  String id = "Newbie";
  Widget _designationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'I am a: ',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 0.5)),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 100,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                width: 160,
                height: 50,
                child: RadioListTile(
                    value: "Newbie",
                    activeColor: Colors.greenAccent[700],
                    dense: true,
                    groupValue: id,
                    onChanged: (value) {
                      setState(() {
                        id = value;
                      });
                    },
                    title: Text(
                      'looking for a house',
                      style: GoogleFonts.quicksand(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 15)),
                    )),
              ),
              Container(
                width: 160,
                height: 50,
                child: RadioListTile(
                  dense: true,
                  activeColor: Colors.greenAccent[700],
                  value: "Tenant",
                  groupValue: id,
                  onChanged: (value) {
                    setState(() {
                      id = value;
                      _showListPopup();
                    });
                  },
                  title: Text(
                    'Tenant',
                    style: GoogleFonts.quicksand(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _registerPassword2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password confirmation',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
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
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          controller: _confirmPass,
          focusNode: _focuscpass,
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
              labelText: 'Please enter your password again',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.vpn_key,
                color: Colors.white,
              )),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password should be 6 or more characters';
            }
            if (value != _passwording.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.done,
          onSaved: _confirmPassHandler,
        )
      ],
    );
  }

  //Generate a timestamp that will be the Landlords unique code
  int lordCode() {
    int code = DateTime.now().microsecondsSinceEpoch;
    return code;
  }

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  API _api = API();

  Future<bool> serverCall() async {
    result = await _api.createUserEmailPass(_user);
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

  void _registerBtnPressed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Populate the user fields based on designation
      if (id == "Tenant") {
        _user = User(
            firstName: _fname,
            lastName: _lname,
            email: _email,
            phone: _phone,
            natId: _natId,
            registerDate: now.toLocal(),
            designation: id,
            apartmentName: apartmentName,
            password: _pass,
            lordCode: 0);
      }
      if (id == "Newbie") {
        _user = User(
          firstName: _fname,
          lastName: _lname,
          email: _email,
          phone: _phone,
          natId: _natId,
          registerDate: now.toLocal(),
          designation: id,
          password: _pass,
        );
      }
      setState(() {
        isLoading = false;
      });

      //Display appropriate response according to results of above feature
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
                  'Thank you for joining us ${_user.firstName}',
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
            Navigator.of(context).popAndPushNamed('/login');
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

  Widget _registerBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
              color: Colors.white,
              onPressed: _registerBtnPressed,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'REGISTER',
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
            onPressed: () => Navigator.pop(context)),
        actions: <Widget>[_signInWidget()],
        elevation: 0.0,
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
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 40),
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
                          'Please fill in the form below to open a new account',
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
                        _designationSelector(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerFirstName(),
                        SizedBox(
                          height: 30,
                        ),
                        _registerOtherName(),
                        SizedBox(
                          height: 30,
                        ),
                        _registerEmail(),
                        SizedBox(
                          height: 30,
                        ),
                        _registerPhone(),
                        SizedBox(
                          height: 30,
                        ),
                        _registerID(),
                        SizedBox(
                          height: 30,
                        ),
                        _registerPassword1(),
                        SizedBox(
                          height: 30,
                        ),
                        _registerPassword2(),
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
