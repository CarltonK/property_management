import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/models/paymentmodel.dart';

class TenantHome extends StatefulWidget {
  @override
  _TenantHomeState createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  //A list to hold payments
  List<Payment> payments = [
    june,
    july,
    august,
    september,
    october,
    november,
    december
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green[900]
              ),
            ),
            Container(
              //This Container lays out the UI
              padding: EdgeInsets.only(top: 30),
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBarLayout(context),
                    SizedBox(
                      height: 10,
                    ),
                    _userFunctions(context, payments),
                    SizedBox(height: 10,),
                    //_landlordDetails(context)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _userFunctions(BuildContext context, List<Payment> payments) {
  return Container(
    padding: EdgeInsets.all(30),
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.green[900],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Payment',
              style: GoogleFonts.muli(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5)),
            ),
            Text(
              'History',
              style: GoogleFonts.muli(
                  textStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 20,
                      letterSpacing: .5)),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: payments.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100]),
                    height: 250,
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${payments[index].month}',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Rent amount',
                              style:
                                  GoogleFonts.quicksand(textStyle: TextStyle()),
                            ),
                            Text(
                              'KES ${payments[index].rent}',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                              )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Rent due',
                              style:
                                  GoogleFonts.quicksand(textStyle: TextStyle()),
                            ),
                            Text(
                              '${payments[index].date.day} '
                              '${payments[index].month} '
                              '${payments[index].date.year}',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                              )),
                            )
                          ],
                        ),
                        Center(
                          child: Container(
                            width: double.maxFinite,
                            margin:
                                EdgeInsets.only(top: 30, right: 20, left: 20),
                            decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(16)),
                            child: FlatButton(
                                onPressed: null,
                                child: Text(
                                  'Pay Now',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _landlordDetails(BuildContext context) {
  return Container(
    //This container shows the landlord details
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: Colors.green[900],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40))),
    padding: EdgeInsets.all(30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Landlord Information',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 22, letterSpacing: .5)),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Stannis Baratheon',
                  style: GoogleFonts.muli(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'stannisbarry@gmail.com',
                  style: GoogleFonts.muli(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: .5)),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              color: Colors.white,
              onPressed: () {
                print('I want to call the landlord');
              },
              minWidth: MediaQuery.of(context).size.width * 0.35,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Call',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5)),
              ),
            ),
            MaterialButton(
              color: Colors.indigo[900],
              onPressed: () {
                print('I want to send an sms to the landlord');
              },
              minWidth: MediaQuery.of(context).size.width * 0.35,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white)),
              child: Text(
                'Send SMS',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5)),
              ),
            )
          ],
        )
      ],
    ),
  );
}


Widget _appBarLayout(context) {
  //This custom appBar replaces the Flutter App Bar
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/tenant-profile');
          },
          child: Container(
            height: 80,
            child: Hero(
              tag: 'tenant',
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(CupertinoIcons.person_solid, color: Colors.green[900],size: 60,),
              ),
            ),
          ),
        ),
        FloatingActionButton(
          elevation: 10,
          mini: false,
          splashColor: Colors.greenAccent[700],
          tooltip: 'Rent reminder',
          onPressed: () {
            print('I want to set a rent reminder');
          },
          backgroundColor: Colors.green[900],
          child: Icon(
            Icons.alarm,
            color: Colors.white,
            size: 30,
          ),
        )
      ],
    ),
  );
}
