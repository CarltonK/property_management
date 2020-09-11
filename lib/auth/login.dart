import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/models/usermodel.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';
import 'package:property_management/widgets/dialogs/error_dialog.dart';
import 'package:property_management/widgets/dialogs/info_dialog.dart';
import 'package:property_management/widgets/utilities/sectionHeader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _focusPass = FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email, _password;
  User _user;

  void _emailHandler(String email) {
    _email = email.toLowerCase().trim();
    print('Email: $_email');
  }

  @override
  void dispose() {
    super.dispose();
    _focusPass.dispose();
    _emailController.clear();
    _passController.clear();
  }

  void _passwordHandler(String pass) {
    _password = pass.trim();
    print('Password: $_password');
  }

  Widget _loginEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: 'Email'),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          autofocus: false,
          controller: _emailController,
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
                color: Colors.white,
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
            FocusScope.of(context).requestFocus(_focusPass);
          },
          textInputAction: TextInputAction.next,
          onSaved: _emailHandler,
        )
      ],
    );
  }

  Widget _loginPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: 'Password'),
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
          obscureText: true,
          focusNode: _focusPass,
          controller: _passController,
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
                color: Colors.white,
                width: 1.5,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            icon: Icon(
              Icons.vpn_key,
              color: Colors.white,
            ),
          ),
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
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.done,
          onSaved: _passwordHandler,
        )
      ],
    );
  }

  void _forgotPasswordBtn() {
    // print('I want to reset my password');
    Navigator.of(context).pushNamed('/reset');
  }

  Widget _loginForgotPass() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: _forgotPasswordBtn,
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.muli(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  API _api = API();

  Future<bool> serverCall() async {
    result = await _api.signInEmailPass(_user);
    print('This is the result: $result');

    if (result == 'Invalid credentials. Please try again') {
      callResponse = false;
      return false;
    } else if (result == "The email format entered is invalid") {
      callResponse = false;
      return false;
    } else if (result == "Please register first") {
      callResponse = false;
      return false;
    } else if (result == "Your account has been disabled") {
      callResponse = false;
      return false;
    } else if (result == "Too many requests. Try again in 2 minutes") {
      callResponse = false;
      return false;
    } else {
      callResponse = true;
      return true;
    }
  }

  Future getUserBase(String uid) async {
    //This is the name of the collection we will be reading
    final String _collection = 'users';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    var document = _fireStore.collection(_collection).document(uid);
    var returnDoc = document.get();
    FirebaseMessaging _messaging = FirebaseMessaging();
    //Show the return value - A DocumentSnapshot;
    //print('This is the return ${returnDoc}');
    returnDoc.then((value) async {
      //Extract values
      String userdesignation = value.data["designation"];
      //Return the data for user
      Map<String, dynamic> userData = value.data;

      //Add the uid to the Map
      userData["uid"] = uid;

      //Try save credentials using shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', uid);

      //Check if the user does not have a token
      if (value.data['token'] == null) {
        String token = await _messaging.getToken();
        await _fireStore.collection(_collection).document(uid).updateData(
          {'token': token},
        );
      }

      //Show different home pages based on designation
      //Tenant Page
      if (userdesignation == "Tenant") {
        //Timed Function
        Timer(Duration(milliseconds: 100), () {
          Navigator.of(context).popAndPushNamed(
            '/tenant-home',
            arguments: userData,
          );
        });
      }
      //Admin Page
      else if (userdesignation == "Admin") {
        //Timed Function
        Timer(Duration(milliseconds: 100), () {
          Navigator.of(context).popAndPushNamed(
            '/admin',
            arguments: userData,
          );
        });
      }
      //Manager page
      else if (userdesignation == "Manager") {
        //Timed Function
        Timer(Duration(milliseconds: 100), () {
          Navigator.of(context).popAndPushNamed(
            '/manager',
            arguments: userData,
          );
        });
      }
      //Service Provider Page
      else if (userdesignation == "Provider") {
        //Timed Function
        Timer(Duration(milliseconds: 100), () {
          Navigator.of(context).popAndPushNamed(
            '/provider-home',
            arguments: userData,
          );
        });
      }
      //Landlord Page
      else if (userdesignation == "Landlord") {
        //Timed Function
        Timer(Duration(milliseconds: 100), () {
          Navigator.of(context).popAndPushNamed(
            '/owner_home',
            arguments: userData,
          );
        });
      } else {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return InfoDialog(message: 'This account is not registered');
          },
        );
      }
    }).catchError((error) {
      //Pop welcome dialog
      Navigator.of(context).pop();

      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(message: 'This account is not available');
        },
      );
    });
  }

  void _loginBtnPressed() {
    print('Login btn pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _user = User(email: _email, password: _password);

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
            return ErrorDialog(message: error.toString());
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
                  'Welcome',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  )),
                ),
                message: Center(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            },
          );
          //Disable the circular progress dialog
          setState(() {
            isLoading = true;
          });
          //This is where we redirect the user based on their designation
          //Pass the user id as the parameter
          String userid = '${result.uid}';
          //print('This is the user id: $userid');
          //Query user designation based on results of the query containing uid
          getUserBase(userid);
        } else {
          //print('Failed response: ${result}');
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

  Widget _loginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
              color: Colors.white,
              onPressed: _loginBtnPressed,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'LOGIN',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.green[900],
                    fontSize: 20,
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

  Widget _signUpWidget() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      onTap: () {
        print('I want to create an account');
        Navigator.of(context).pushNamed('/register');
      },
      splashColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'SIGN UP',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: Colors.green[900],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
        actions: <Widget>[_signUpWidget()],
        elevation: 0.0,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                          'Welcome',
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
                          'Login to your account now',
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
                        _loginEmail(),
                        SizedBox(
                          height: 30,
                        ),
                        _loginPassword(),
                        SizedBox(
                          height: 10,
                        ),
                        _loginForgotPass(),
                        SizedBox(
                          height: 10,
                        ),
                        _loginBtn(),
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
