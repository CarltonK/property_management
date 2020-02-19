import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final _focusPass =  FocusNode();

  String _email, _password;

  void _emailHandler(String email){
    _email = email;
    print('Email: $_email');
  }

  void _passwordHandler(String pass){
    _password = pass;
    print('Password: $_password');
  }

  Widget _loginEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              letterSpacing: .2,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18
            )
          ),
          decoration: InputDecoration(
            errorStyle: GoogleFonts.quicksand(
              textStyle: TextStyle(
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.indigo,
                width: 1.5
              )
            ),

            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red
              )
            ),
            labelText: 'Please enter your email',
            labelStyle: GoogleFonts.quicksand(
              textStyle: TextStyle(

              )
            ),
            icon: Icon(Icons.email)
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty){
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
        Text(
          'Password',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  letterSpacing: .2,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18
              )
          ),
          obscureText: true,
          focusNode: _focusPass,
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.indigo,
                      width: 1.5
                  )
              ),

              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red
                  )
              ),
              labelText: 'Please enter your password',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(

                  )
              ),
              icon: Icon(Icons.vpn_key)
          ),
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value.isEmpty){
              return 'Password is required';
            }
            if (value.length < 6){
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
    print('I want to reset my password');
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
                color: Colors.black,
                fontSize: 18,
              )),
        ),
      ),
    );
  }

  void _loginBtnPressed() {
    print('Login btn pressed');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Navigator.of(context).pushNamed('/tenant-home');
    }

  }

  Widget _loginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: RaisedButton(
        color: Colors.indigo,
          onPressed: _loginBtnPressed,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          child: Text(
              'LOGIN',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500
            )
          ),),),
    );
  }

  Widget _signUpWidget() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25)
          )
      ),
      onTap: () {
        print('I want to create an account');
        Navigator.of(context).pushNamed('/register');
      },
      splashColor: Colors.grey,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.symmetric(
            vertical: 4
        ),
        decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30)
            )
        ),
        child: Center(
          child: Text(
            'SIGN UP',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                )
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
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: Colors.black,),
            onPressed: null),
        actions: <Widget>[
          _signUpWidget()
        ],
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
                  color: Colors.white
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 50
                  ),
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              letterSpacing: 0.5
                            )
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Login to your account now',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  letterSpacing: 0.5
                              )
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
