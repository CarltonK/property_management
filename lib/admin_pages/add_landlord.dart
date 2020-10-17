import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/models/countymodel.dart';
import 'package:property_management/models/usermodel.dart';
import 'package:property_management/widgets/dialogs/info_dialog.dart';

class AddLandlord extends StatefulWidget {
  @override
  _AddLandlordState createState() => _AddLandlordState();
}

class _AddLandlordState extends State<AddLandlord> {
  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  final _formKey = GlobalKey<FormState>();

  final _focusnatid = FocusNode();
  final _focuspaybill = FocusNode();
  final _focusapartment = FocusNode();
  final _focusemail = FocusNode();
  final _focusphone = FocusNode();
  final _focusLocation = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _focusemail.dispose();
    _focuspaybill.dispose();
    _focusapartment.dispose();
    _focusphone.dispose();
    _focusnatid.dispose();
    _focusLocation.dispose();
  }

  String _fullName,
      _natId,
      _phone,
      _paybill = '',
      _apartmentName,
      _location,
      _email;
  int _lordCode;
  User _user;

  void _emailHandler(String value) {
    _email = value.toLowerCase().trim();
    print('Email: $_email');
  }

  void _fullNameHandler(String value) {
    _fullName = value.trim();
    print('Full Name: $_fullName');
  }

  void _nationalIdHandler(String value) {
    _natId = value.trim();
    print('National ID: $_natId');
  }

  void _phoneHandler(String value) {
    _phone = value.trim();
    print('Phone: $_phone');
  }

  void _locationHandler(String value) {
    _location = value.trim();
    print('Location: $_location');
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
          'Full Name',
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
              labelText: 'Enter full names',
              helperText: 'Be sure to use a space',
              helperStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.person,
                color: Colors.white,
              )),
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

//  Widget _registerOtherName() {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Text(
//          'Surname',
//          style: GoogleFonts.quicksand(
//              textStyle: TextStyle(
//                  color: Colors.white,
//                  fontSize: 20,
//                  letterSpacing: .2,
//                  fontWeight: FontWeight.bold)),
//        ),
//        SizedBox(
//          height: 10,
//        ),
//        TextFormField(
//          autofocus: false,
//          style: GoogleFonts.quicksand(
//              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
//          focusNode: _focuslname,
//          decoration: InputDecoration(
//              errorStyle: GoogleFonts.quicksand(
//                textStyle: TextStyle(color: Colors.white),
//              ),
//              enabledBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.white)),
//              focusedBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
//              errorBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.red)),
//              labelText: 'Please enter your surname',
//              labelStyle: GoogleFonts.quicksand(
//                  textStyle: TextStyle(color: Colors.white)),
//              icon: Icon(
//                Icons.person,
//                color: Colors.white,
//              )),
//          keyboardType: TextInputType.text,
//          validator: (value) {
//            if (value.isEmpty) {
//              return 'Surname is required';
//            }
//            return null;
//          },
//          onFieldSubmitted: (value) {
//            FocusScope.of(context).requestFocus(_focusemail);
//          },
//          textInputAction: TextInputAction.next,
//          onSaved: _lastNameHandler,
//        )
//      ],
//    );
//  }

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
              labelText: 'Enter email',
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
              labelText: 'Enter phone number',
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
              return 'Phone number should start with "07"';
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
              labelText: 'Enter ID',
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
              labelText: 'Name of the building',
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
            FocusScope.of(context).requestFocus(_focusLocation);
          },
          textInputAction: TextInputAction.next,
          onSaved: _apartmentHandler,
        )
      ],
    );
  }

  Widget _registerApartmentLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Apartment Location',
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
          focusNode: _focusLocation,
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
              labelText: 'E.g: Langata, Nairobi',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              )),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Apartment location is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focuspaybill);
          },
          textInputAction: TextInputAction.next,
          onSaved: _locationHandler,
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
              labelText: 'Safaricom paybill',
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
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'SUBMIT',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.green[900],
                      fontSize: 20,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
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
    if (countyName == null) {
      //Show an action sheet with error
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(message: 'You have not selected a county');
        },
      );
    } else {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        //Display the Circular Loading Indicator
        setState(() {
          isLoading = false;
        });

        _user = User(
          fullName: _fullName,
          email: _email,
          natId: _natId,
          phone: _phone,
          apartmentName: _apartmentName,
          location: _location,
          paybill: _paybill,
          designation: "Landlord",
          county: countyName,
          registerDate: DateTime.now().toLocal(),
          lordCode: lordCodeGenerator(),
        );

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
                  message: Text(
                    'We have added $_fullName\nOwner of $_apartmentName',
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
  }

  String countyName;

  List<County> counties = <County>[
    County(name: 'Nairobi'),
    County(name: 'Kiambu'),
    County(name: 'Mombasa'),
    County(name: 'Kisumu'),
    County(name: 'Nakuru'),
//    County(name: 'Kwale'),
//    County(name: 'Kilifi'),
//    County(name: 'Tana River'),
//    County(name: 'Lamu'),
//    County(name: 'Taita Taveta'),
//    County(name: 'Garissa'),
//    County(name: 'Wajir'),
//    County(name: 'Mandera'),
//    County(name: 'Marsabit'),
//    County(name: 'Isiolo'),
//    County(name: 'Meru'),
//    County(name: 'Tharaka Nithi'),
//    County(name: 'Embu'),
//    County(name: 'Kitui'),
//    County(name: 'Machakos'),
//    County(name: 'Makueni'),
//    County(name: 'Nyandarua'),
//    County(name: 'Nyeri'),
//    County(name: 'Kirinyaga'),
//    County(name: 'Murang\'a'),
//    County(name: 'Turkana'),
//    County(name: 'West Pokot'),
//    County(name: 'Samburu'),
//    County(name: 'Trans-Nzoia'),
//    County(name: 'Uasin Gishu'),
//    County(name: 'Elgeyo Marakwet'),
//    County(name: 'Nandi'),
//    County(name: 'Baringo'),
//    County(name: 'Laikipia'),
//    County(name: 'Narok'),
//    County(name: 'Kajiado'),
//    County(name: 'Kericho'),
//    County(name: 'Bomet'),
//    County(name: 'Kakamega'),
//    County(name: 'Vihiga'),
//    County(name: 'Bungoma'),
//    County(name: 'Busia'),
//    County(name: 'Siaya'),
//    County(name: 'Homa Bay'),
//    County(name: 'Migori'),
//    County(name: 'Kisii'),
//    County(name: 'Nyamira'),
  ];

  Widget _dropDownCounties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'County',
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
        DropdownButton<String>(
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
            value: countyName,
            items: counties.map((map) {
              return DropdownMenuItem<String>(
                  value: map.name,
                  child: Text(map.name,
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))));
            }).toList(),
            onChanged: (value) {
              setState(() {
                countyName = value;
              });
              print("County: $countyName");
            }),
      ],
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      title: Text(
        'Create Landlord',
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget subheader(String text) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
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
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        subheader('Personal Details'),
                        SizedBox(
                          height: 30,
                        ),
                        _registerFirstName(),
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
                        subheader('Apartment Details'),
                        SizedBox(
                          height: 40,
                        ),
                        _registerApartment(),
                        SizedBox(
                          height: 20,
                        ),
                        _dropDownCounties(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerApartmentLocation(),
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
