import 'package:add_2_calendar/add_2_calendar.dart';
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
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

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

  DateTime _setDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/tenant-profile', arguments: user);
          },
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
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(
//                Icons.alarm,
//                color: Colors.white,
//                size: 30,
//              ),
//              onPressed: () {
//                print('I want to set a rent reminder');
//                showCupertinoModalPopup(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return CupertinoActionSheet(
//                        title: Text(
//                          'Pick a Date',
//                          style: GoogleFonts.quicksand(
//                              textStyle: TextStyle(
//                            fontWeight: FontWeight.w600,
//                            fontSize: 20,
//                            color: Colors.black,
//                          )),
//                        ),
//                        message: Container(
//                          height: 100,
//                          child: CupertinoDatePicker(
//                            maximumDate: DateTime.now().add(Duration(days: 31)),
//                            onDateTimeChanged: (value) {
//                              _setDate = value;
//                            },
//                            maximumYear: DateTime.now().year,
//                            mode: CupertinoDatePickerMode.date,
//                            initialDateTime: _setDate,
//                          ),
//                        ),
//                        cancelButton: CupertinoActionSheetAction(
//                            onPressed: () {
//                              _eventSetter(_setDate);
//                              print(_setDate);
//                              Navigator.of(context).pop();
//                            },
//                            child: Text(
//                              'SET DATE',
//                              style: GoogleFonts.muli(
//                                  textStyle: TextStyle(
//                                      color: Colors.red,
//                                      fontSize: 25,
//                                      fontWeight: FontWeight.bold)),
//                            )));
//                  },
//                );
//              })
//        ],
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
              //This Container lays out the UI
              padding: EdgeInsets.only(top: 30),
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    _userFunctions(context, payments),
                    SizedBox(
                      height: 10,
                    ),
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

  void _eventSetter(DateTime setDate) {
    setDate = _setDate.add(Duration(days: 30));
    final Event event = Event(
        title: 'Rent reminder',
        description: 'I want to pay my rent on this day',
        startDate: setDate,
        endDate: setDate,
        allDay: true);

    Add2Calendar.addEvent2Cal(event).catchError((error) {
      showDialog(
          context: context,
          child: CupertinoAlertDialog(
            content: Text(
              'We encountered an error when setting your reminder. Please try again',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
              )),
            ),
          ));
    });
    // .whenComplete(() {
    //   showDialog(
    //       context: context,
    //       child: CupertinoAlertDialog(
    //         content: Text(
    //           'Redirecting you to your calendar',
    //           style: GoogleFonts.quicksand(
    //               textStyle: TextStyle(
    //             color: Colors.black,
    //             fontSize: 20,
    //           )),
    //         ),
    //       ));
    // });
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
