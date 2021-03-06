import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/models/usermodel.dart';
import 'package:property_management/widgets/dialogs/error_dialog.dart';
import 'package:property_management/widgets/dialogs/info_dialog.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';
import 'package:property_management/widgets/utilities/sectionHeader.dart';

class NewTenant extends StatefulWidget {
  @override
  _NewTenantState createState() => _NewTenantState();
}

class _NewTenantState extends State<NewTenant> {
  User _user;
  final _formKey = GlobalKey<FormState>();

  //Save Registration Date
  var now = DateTime.now();

//  final _focuslname = FocusNode();
  final _focusemail = FocusNode();
//  final _focusphone = FocusNode();
//  final _focusnatid = FocusNode();
  final _focuspass = FocusNode();
  final _focuscpass = FocusNode();

  String _fullName, _email, _pass, _cpass;
//String _phone, _natId, _lname;
  String apartmentName;
//Network status
  dynamic isConnected;

  final TextEditingController _passwording = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  void _emailHandler(String email) {
    _email = email.trim();
    print('Email: $_email');
  }

//  void _phoneHandler(String phone) {
//    _phone = phone.trim();
//    print('Phone: $_phone');
//  }

  void _fullNameHandler(String name) {
    _fullName = name.trim();
    print('Name: $_fullName');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //Dispose the FocusNodes
//    _focuslname.dispose();
    _focusemail.dispose();
//    _focusphone.dispose();
//    _focusnatid.dispose();
    _focuspass.dispose();
    _focuscpass.dispose();
    //Dispose the TextEditingControllers
    _passwording.dispose();
    _confirmPass.dispose();
  }

//  void _natIdHandler(String id) {
//    _natId = id.trim();
//    print('National ID: $_natId');
//  }

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
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
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
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'SIGN IN',
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

  Widget _dropDownApartments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: 'Apartment'),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("apartments").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            } else {
              return DropdownButton<String>(
                underline: Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 1.5,
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 30,
                ),
                isExpanded: true,
                value: apartmentName,
                items: snapshot.data.documents.map((map) {
                  return DropdownMenuItem<String>(
                    value: map["apartment_name"],
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      color: Colors.green[900],
                      child: Text(
                        map["apartment_name"],
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    apartmentName = value;
                  });
                  print(apartmentName);
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _registerFullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: 'Name'),
        SizedBox(
          height: 5,
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
            helperText: 'Be sure to use a space',
            helperStyle: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Full Name is required';
            }
            if (!value.contains(' ')) {
              return 'Remember to use a space';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusemail);
          },
          textInputAction: TextInputAction.next,
          onSaved: _fullNameHandler,
        )
      ],
    );
  }

  Widget _registerEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: 'Email'),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autofocus: false,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          focusNode: _focusemail,
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
            if (!value.contains('@')) {
              return 'Your email should have "@"';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focuspass);
          },
          textInputAction: TextInputAction.next,
          onSaved: _emailHandler,
        )
      ],
    );
  }

  Widget _registerPassword1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: 'Password'),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autofocus: false,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          controller: _passwording,
          focusNode: _focuspass,
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

  Widget _registerPassword2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: 'Password Confirmation'),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autofocus: false,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          controller: _confirmPass,
          focusNode: _focuscpass,
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
    } else if (result == null) {
      result = "Please check your internet connection";
      callResponse = false;
      return false;
    } else {
      callResponse = true;
      return true;
    }
  }

  //Return user data
  Future navigateUser(String uid) async {
    //This is the name of the collection we will be reading
    final String _collection = 'users';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    var document = _fireStore.collection(_collection).document(uid);
    var returnDoc = document.get();
    returnDoc.then((value) {
      Map<String, dynamic> data = value.data;
      Navigator.of(context).pushReplacementNamed(
        '/tenant-home',
        arguments: data,
      );
    });
  }

  void _registerBtnPressed() {
    if (apartmentName == null) {
      //Show an action sheet with error
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(message: 'Please select an apartment');
        },
      );
    } else if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Populate the user fields based on designation
      _user = User(
        fullName: _fullName,
        email: _email,
        registerDate: now,
        designation: "Tenant",
        apartmentName: apartmentName,
        password: _pass,
        lordCode: 0,
      );

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
          print('Successful response $result');
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return InfoDialog(
                message:
                    'Thank you for joining us ${_user.fullName.split(' ')[0]}',
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
            navigateUser(result.uid);
          });
          //Retreieve user details and push to home page

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
              return ErrorDialog(message: result.toString());
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
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'REGISTER',
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

  Widget body() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ConnectionStatusBar(
            //   height: 30,
            //   animationDuration: Duration(milliseconds: 500),
            //   color: Colors.black,
            //   title: Text(
            //     'Please check your internet connection',
            //     style: GoogleFonts.quicksand(
            //       textStyle: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            Text(
              'Hello',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Please fill in the form below to open a new tenant account',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 30),
            _dropDownApartments(),
            SizedBox(
              height: 25,
            ),
            _registerFullName(),
            SizedBox(
              height: 25,
            ),
            _registerEmail(),
            SizedBox(
              height: 25,
            ),
            _registerPassword1(),
            SizedBox(
              height: 25,
            ),
            _registerPassword2(),
            SizedBox(
              height: 20,
            ),
            _registerBtn()
          ],
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
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0.0,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                BackgroundColor(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  height: MediaQuery.of(context).size.height,
                  child: body(),
                ),
              ],
            ),
          ),
        ));
  }
}
