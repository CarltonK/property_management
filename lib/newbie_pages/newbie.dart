import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Newbie extends StatefulWidget {
  @override
  _NewbieState createState() => _NewbieState();
}

class _NewbieState extends State<Newbie> {
  double _bedroomCount = 1;

  RangeValues range = RangeValues(0, 15000);
  int resultsFound = 0;

  Future<int> _getListings(int rooms, int min, int max) async {
    print('We want to perform this query');
    final String collection = "listings";
    QuerySnapshot query = await Firestore.instance
        .collection(collection)
        .where("bedrooms", isEqualTo: rooms)
        .where("price", isLessThanOrEqualTo: max)
        .where("price", isGreaterThanOrEqualTo: min)
        .orderBy("price", descending: true)
        .getDocuments();
    resultsFound = query.documents.length;
    print('Listings found: $resultsFound');
    return resultsFound;
  }

  List<RangeValues> ranges = <RangeValues>[
    RangeValues(0, 15000),
    RangeValues(15001, 25000),
    RangeValues(25001, 35000),
    RangeValues(35001, 45000),
    RangeValues(45001, 55000),
    RangeValues(55001, 65000),
    RangeValues(65001, 100000)
  ];

  Widget _dropDownRanges() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.green[900], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              'Price',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownButton<RangeValues>(
              underline: Divider(
                color: Colors.white,
                height: 2,
                thickness: 1.5,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 30,
              ),
              items: ranges.map((map) {
                return DropdownMenuItem<RangeValues>(
                    value: map,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      color: Colors.green[900],
                      child: Text('${map.start} - ${map.end}',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ));
              }).toList(),
              isExpanded: true,
              value: range,
              onChanged: (value) {
                setState(() {
                  range = value;
                });
//                print("Range: $range");
//                print('Start value: ${range.start}');
//                print('End value: ${range.end}');
              }),
        ],
      ),
    );
  }

  Widget _bedroomSelector() {
    return Card(
      elevation: 20,
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.green[700], borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bedrooms',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500)),
            ),
            Text(
              _bedroomCount.toInt() == 0
                  ? 'Bedsitter'
                  : '${_bedroomCount.toInt()}',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontSize: _bedroomCount.toInt() == 0 ? 30 : 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  '0',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500)),
                ),
                Slider.adaptive(
                    min: 0,
                    max: 5,
                    divisions: 5,
                    value: _bedroomCount,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _bedroomCount = value;
                      });
                    }),
                Text(
                  '5',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future payToView(String phone, int beds, int min, int max) async {
    await Firestore.instance.collection("bookings").document().setData({
      "phone": phone,
      "approved": false,
      "bedrooms": beds,
      "min": min,
      "max": max
    });
  }

  String phone;
  final _formKey = GlobalKey<FormState>();

  void _phoneHandler(String value) {
    phone = value.trim();
    print('Phone: $phone');
  }

  Widget _addPhone(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black, fontSize: 18)),
      decoration: InputDecoration(
        errorStyle: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black),
        ),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value.isEmpty) {
          return 'Phone number is required';
        }
        if (!value.startsWith('07')) {
          return 'Phone number should start with "07"';
        }
        if (value.length != 10) {
          return 'Phone number should be 10 characters';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.done,
      onSaved: _phoneHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Kejani',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
        ),
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
                color: Colors.green[900],
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _bedroomSelector(),
                      SizedBox(
                        height: 30,
                      ),
                      _dropDownRanges(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.green[900],
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Search Results: ',
                              style: GoogleFonts.muli(
                                  textStyle: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Text(
                              '$resultsFound',
                              style: GoogleFonts.muli(
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        splashColor: Colors.greenAccent[700],
        onPressed: () {
          if (resultsFound == 0) {
            if (range == null) {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                      title: Text(
                        'Please select a price range',
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
              Map<String, dynamic> _priceData = {
                "min": range.start.toInt(),
                "max": range.end.toInt()
              };
              print('Bedrooms: ${_bedroomCount.toInt()}');
              print('Price: $_priceData');
              _getListings(_bedroomCount.toInt(), range.start.toInt(),
                      range.end.toInt())
                  .then((value) {
                setState(() {
                  resultsFound = value;
                });
              });
            }
          } else {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                    title: Text(
                      'We found $resultsFound listings',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      )),
                    ),
                    message: Text(
                      'To view results you will be required to pay a small fee of KES 50',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black,
                      )),
                    ),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                          onPressed: () {
                            //Navigator.of(context).pop();
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    title: Text(
                                      'Your phone number is required. We will be in touch with you',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                    ),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            _addPhone(context),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'CANCEL',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                        ),
                                        color: Colors.red,
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();

                                            payToView(
                                                    phone,
                                                    _bedroomCount.toInt(),
                                                    range.start.toInt(),
                                                    range.end.toInt())
                                                .then((value) {
                                              Navigator.of(context).pop();
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoActionSheet(
                                                      title: Text(
                                                        'Your booking request is being processed',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        )),
                                                      ),
                                                      message: Text(
                                                        'Please enter your M-PESA pin in the popup',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        )),
                                                      ),
                                                    );
                                                  });
                                            });
                                          }
                                        },
                                        child: Text(
                                          'SEND',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                        ),
                                        color: Colors.green,
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'OK I UNDERSTAND',
                            style: GoogleFonts.muli(
                                textStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ))
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        )));
              },
            );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              resultsFound == 0 ? Icons.search : Icons.vpn_key,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              resultsFound == 0 ? 'Search' : 'Unlock results',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            )
          ],
        ),
      ),
    );
  }
}
