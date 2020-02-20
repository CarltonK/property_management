import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();

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
    _email = email;
    print('Email: $_email');
  }

  void _phoneHandler(String phone) {
    _phone = phone;
    print('Phone: $_phone');
  }

  void _firstNameHandler(String name1) {
    _fname = name1;
    print('First Name: $_fname');
  }

  void _lastNameHandler(String name2) {
    _lname = name2;
    print('Last Name: $_lname');
  }

  void _natIdHandler(String id) {
    _natId = id;
    print('National ID: $_natId');
  }

  void _passHandler(String password) {
    _pass = password;
    print('Password(1): $_pass');
  }

  void _confirmPassHandler(String confirmation) {
    _cpass = confirmation;
    print('Password(2): $_cpass');
  }

  Widget _signInWidget() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
      onTap: () {
        print('I want to sign in');
        Navigator.of(context).pop();
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
                    color: Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
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
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your first name',
              labelStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white
                )
              ),
              icon: Icon(Icons.person, color: Colors.white,)),
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
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focuslname,
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
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your other names',
              labelStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white
                )
              ),
              icon: Icon(Icons.person, color: Colors.white,)),
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
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focusemail,
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
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
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
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focusphone,
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
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your phone number',
              labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(
                color: Colors.white
              )),
              icon: Icon(Icons.phone, color: Colors.white,)),
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
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          focusNode: _focusnatid,
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
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Enter your identification number)',
              labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(
                color: Colors.white
              )),
              icon: Icon(Icons.perm_identity, color: Colors.white,)),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Identification number is required';
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
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          controller: _passwording,
          focusNode: _focuspass,
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
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your password',
              labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(
                color: Colors.white
              )),
              icon: Icon(Icons.vpn_key, color: Colors.white,)),
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
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          controller: _confirmPass,
          focusNode: _focuscpass,
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
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              labelText: 'Please enter your password again',
              labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(
                color: Colors.white
              )),
              icon: Icon(Icons.vpn_key, color: Colors.white,)),
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

  void _registerBtnPressed() {
    print('Register btn pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  Widget _registerBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: RaisedButton(
        color: Colors.white,
        onPressed: _registerBtnPressed,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Text(
          'REGISTER',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
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
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.indigo,
                          Colors.indigo[700],
                          Colors.indigo[900]
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight)
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
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
