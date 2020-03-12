import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TenSearch extends StatefulWidget {
  @override
  _TenSearchState createState() => _TenSearchState();
}

class _TenSearchState extends State<TenSearch> {
  double _bedroomCount = 1;
  var selectedRange = RangeValues(5000, 15000);

  RangeValues range;

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
                    child: Text('${map.start} - ${map.end}',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold))));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 30,
          ),
        ),
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
                decoration: BoxDecoration(color: Colors.green[900]),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        elevation: 20,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(12)),
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
                                        fontSize: _bedroomCount.toInt() == 0
                                            ? 30
                                            : 35,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                      max: 4,
                                      divisions: 4,
                                      value: _bedroomCount,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white,
                                      onChanged: (value) {
                                        setState(() {
                                          _bedroomCount = value;
                                        });
                                      }),
                                  Text(
                                    '4',
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
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _dropDownRanges(),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Card(
                          elevation: 50,
                          shape: CircleBorder(),
                          child: MaterialButton(
                            height: 100,
                            shape: CircleBorder(),
                            onPressed: () {
                              Map<String, dynamic> _priceData = {
                                "min": range.start.toInt(),
                                "max": range.end.toInt()
                              };
                              print('Bedrooms: ${_bedroomCount.toInt()}');
                              print('Price: ${_priceData}');
                            },
                            child: Text(
                              'View results',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
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
    );
  }
}
