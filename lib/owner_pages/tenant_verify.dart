import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantVerify extends StatefulWidget {
  @override
  _TenantVerifyState createState() => _TenantVerifyState();
}

class _TenantVerifyState extends State<TenantVerify> {
  Map<String, dynamic> data;

  final _formKey = GlobalKey<FormState>();

  String _hseNumber;
  String _rentAmt;
  final _focusHse = FocusNode();
  DateTime _vacateDate;

  void _rentAmtHandler(String value) {
    _rentAmt = value.trim();
    print('Rent: $_rentAmt');
  }

  void _hseHandler(String value) {
    _hseNumber = value.trim();
    print('House Number: $_hseNumber');
  }

  int _floor;

  List<int> floors = <int>[0, 1, 2, 3, 4, 5];

  Widget _dropDownFloors(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: DropdownButton<int>(
              hint: Text(
                'Floor',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
              ),
              underline: Divider(
                color: Colors.white,
                height: 1,
                thickness: 1,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 30,
              ),
              items: floors.map((map) {
                return DropdownMenuItem<int>(
                    value: map,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      color: Colors.green[900],
                      child: Text('${map.toString()}',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ));
              }).toList(),
              isExpanded: true,
              value: _floor,
              onChanged: (value) {
                setState(() {
                  _floor = value;
                });
                print('Floor: $_floor');
              }),
        )
      ],
    );
  }

  Future _updateFields(String docId, int code, String amt, DateTime due,
      String hseNumber, int floorNumber, String name) async {
    //Update users first
    await Firestore.instance.collection("users").document(docId).updateData({
      "landlord_code": code,
      "hseNumber": hseNumber,
      "approved": true,
      "floorNumber": floorNumber,
      "rent": amt,
      "due": due
    });

    await Firestore.instance.collection("tenants").document(docId).updateData({
      "landlord_code": code,
      "hseNumber": hseNumber,
      "approved": true,
      "floorNumber": floorNumber,
      "rent": amt,
      "due": due
    });

    await Firestore.instance
        .collection("apartments")
        .document(code.toString())
        .collection("floors")
        .document(floorNumber.toString())
        .setData({"floorNumber": floorNumber});

    await Firestore.instance
        .collection("apartments")
        .document(code.toString())
        .collection("floors")
        .document(floorNumber.toString())
        .collection("tenants")
        .document(docId)
        .setData({
      "name": name,
      "uid": docId,
      "hseNumber": hseNumber,
      "rent": amt,
      "due": due
    });

    setState(() {
      isLoading = true;
    });
  }

  Widget _setNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'House Number',
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
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5)),
            errorBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
//              labelText: 'Please enter your full name',
//              labelStyle: GoogleFonts.quicksand(
//                  textStyle: TextStyle(color: Colors.white)),
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'House Number is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusHse);
          },
          textInputAction: TextInputAction.next,
          onSaved: _hseHandler,
        )
      ],
    );
  }

  Widget _setRent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Rent Amount',
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
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5)),
            errorBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
          keyboardType: TextInputType.number,
          focusNode: _focusHse,
          validator: (value) {
            if (value.isEmpty) {
              return 'Rent Amount is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.done,
          onSaved: _rentAmtHandler,
        )
      ],
    );
  }

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  void _approveBtnPressed() {
    if (_floor == null) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: Text(
                'You have not selected a floor number',
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
                    FocusScope.of(context).unfocus();
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
    } else if (_vacateDate == null) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: Text(
                'Please select a date',
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
                    FocusScope.of(context).unfocus();
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
    } else {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        //Get the docId which is the uid of the tenant
        setState(() {
          isLoading = false;
        });
        String docId = data["docId"];
        print('The docId is: $docId');
        //Update necessary documents (tenants and users)
        _updateFields(docId, data["code"], _rentAmt, _vacateDate, _hseNumber,
                _floor, data["fullName"])
            .whenComplete(() {
          print('Successful response $result');
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                title: Text(
                  'The tenant has been approved',
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
        });
      }
    }
  }

  Widget _approveBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
              color: Colors.white,
              onPressed: _approveBtnPressed,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'APPROVE',
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
    data = ModalRoute.of(context).settings.arguments;
    print('Tenant data received = $data');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Kejani',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.green[900]),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(
                              '${data["fullName"]}',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: .2,
                                      fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${data["apartment_name"]}',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: .2,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Text(
                                  '${data["email"]}',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: .2,
                                          fontWeight: FontWeight.w500)),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _dropDownFloors(context),
                        SizedBox(
                          height: 20,
                        ),
                        _setNumber(),
                        SizedBox(
                          height: 20,
                        ),
                        _setRent(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'The rent is due on:- ',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: .2,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DatePickerTimeline(
                          DateTime.now(),
                          height: 100,
                          selectionColor: Colors.greenAccent[700],
                          onDateChange: (date) {
                            _vacateDate = date;
                            print('$_vacateDate');
                          },
                          daysCount: 90,
                          dateTextStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          monthTextStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          dayTextStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _approveBtn()
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
