import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/models/countymodel.dart';

class AddApartment extends StatefulWidget {
  @override
  _AddApartmentState createState() => _AddApartmentState();
}

class _AddApartmentState extends State<AddApartment> {
  //Retrieve data from tenant prof
  Map<String, dynamic> data;

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  final _formKey = GlobalKey<FormState>();

  final _focuspaybill = FocusNode();
  final _focusapartment = FocusNode();
  final _focusLocation = FocusNode();

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

  String _paybill = '', _apartmentName, _location;
  int _lordCode;

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
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green[900],
                    padding: EdgeInsets.all(8),
                    child: Text(map.name,
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ));
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

  void _submitBtnPressed() async {
    if (countyName == null) {
      //Show an action sheet with error
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
                title: Text(
                  'You have not selected a county',
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
          });
    } else {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        //Display the Circular Loading Indicator
        setState(() {
          isLoading = false;
        });

        //Save to 'apartments' collection
        final String collection = 'apartments';
        //Generate the lordcode
        _lordCode = lordCodeGenerator();
        final String docId = _lordCode.toString();

        await Firestore.instance
            .collection(collection)
            .document(docId)
            .setData({
          "owner": data['firstName'],
          "add_date": DateTime.now().toLocal(),
          "county": countyName,
          "location": _location,
          "paybill": _paybill,
          "apartment_name": _apartmentName,
          "apartment_code": _lordCode
        });

        FocusScope.of(context).unfocus();

        setState(() {
          isLoading = true;
        });

        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                title: Text(
                  'Apartment has been added successfully',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  )),
                ),
                message: SpinKitCircle(
                  color: Colors.red,
                  size: 50,
                ),
              );
            });

        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print('Apartment Add: $data');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Add apartment',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.green[900],
            ),
            Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _dropDownCounties(),
                      SizedBox(
                        height: 20,
                      ),
                      _registerApartment(),
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
    );
  }
}
