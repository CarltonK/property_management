import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TenSearch extends StatefulWidget {
  @override
  _TenSearchState createState() => _TenSearchState();
}

class _TenSearchState extends State<TenSearch> {
  double _bedroomCount = 1;
  double _price = 7000;
  var selectedRange = RangeValues(5000, 15000);

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
                        height: 20,
                      ),
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
                                'Price',
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Text(
                                '${selectedRange.start.toInt()} - ${selectedRange.end.toInt()}',
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    '5000',
                                    style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  RangeSlider(
                                      min: 5000,
                                      max: 50000,
                                      divisions: 20,
                                      values: selectedRange,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white,
                                      onChanged: (newRange) {
                                        setState(() {
                                          selectedRange = newRange;
                                        });
                                      }),
                                  Text(
                                    '50000',
                                    style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontSize: 20,
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
                        height: 30,
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
                                "min": selectedRange.start.toInt(),
                                "max": selectedRange.end.toInt()
                              };
                              print('Bedrooms: ${_bedroomCount.toInt()}');
                              print('Price: ${_priceData}');
                            },
                            child: Text(
                              'Pay to view',
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
