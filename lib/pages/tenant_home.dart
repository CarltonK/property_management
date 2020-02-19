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
              //This container lays out the theme of the page
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.indigo),
            ),
            Container(
              //This Container lays out the UI
              padding: EdgeInsets.only(top: 40),
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBarLayout(),
                    SizedBox(
                      height: 30,
                    ),
                    _rowTenantDetails(context),
                    SizedBox(
                      height: 30,
                    ),
                    _landlordDetails(context),
                    _userFunctions(context, payments),
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
    padding: EdgeInsets.all(40),
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40))
    ),
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
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5)),
            ),
            Text(
              'History',
              style: GoogleFonts.muli(
                  textStyle: TextStyle(
                      color: Colors.grey,
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
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: payments.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300]
                    ),
                    height: 200,
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${payments[index].month}',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24
                              )
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Rent amount',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                  )
                              ),
                            ),
                            Text(
                              'KES ${payments[index].rent}',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )
                              ),
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
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                  )
                              ),
                            ),
                            Text(
                              '${payments[index].date.day} '
                                  '${payments[index].month} '
                                  '${payments[index].date.year}',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(
                              top: 30,
                              right: 20,
                              left: 20
                            ),
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: FlatButton(
                                onPressed: null,
                                child: Text(
                                  'Pay Now',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
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
        SizedBox(
          height: 30,
        ),
        Text(
          'Complaint',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5)),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey[50]
                  ),
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () {
                          print('I want to add a new complaint');
                        },
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, color: Colors.indigo, size: 30,),),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Add New',
                        style: GoogleFonts.muli(
                            textStyle: TextStyle(
                                color: Colors.indigo,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5)),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.pink[50]
                  ),
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '4',
                        style: GoogleFonts.muli(
                            textStyle: TextStyle(
                                color: Colors.indigo,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Complaints',
                        style: GoogleFonts.muli(
                            textStyle: TextStyle(
                                color: Colors.indigo,
                                fontSize: 20,
                                letterSpacing: .5)),
                      )
                    ],
                  ),
                ),
              )
            ],
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
      gradient: LinearGradient(
          colors: [
            Colors.indigo,
            Colors.indigo[800]
          ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter),
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40))),
    padding: EdgeInsets.all(40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Landlord Information',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: .5)),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 20,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Call',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.indigo,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5)),
              ),),
            MaterialButton(
              color: Colors.indigo,
              onPressed: () {
                print('I want to send an sms to the landlord');
              },
              minWidth: MediaQuery.of(context).size.width * 0.35,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                      color: Colors.white
                  )),
              child: Text(
                'Send SMS',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5)),
              ),)
          ],
        )
      ],
    ),
  );
}

Widget _rowTenantDetails(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/tenant-profile');
          },
          child: Hero(
            tag: 'tenant',
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          'Hello, Jon',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 20, letterSpacing: .5)),
        )
      ],
    ),
  );
}

Widget _appBarLayout() {
  //This custom appBar replaces the Flutter App Bar
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Home',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
        ),
        MaterialButton(
          color: Colors.black,
          onPressed: () {
            print('I want to set the reminder');
          },
          padding: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: <Widget>[
              Icon(Icons.alarm, color: Colors.white,),
              SizedBox(
                width: 5,
              ),
              Text(
                'Rent Reminder',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(color: Colors.white, letterSpacing: .5)),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
