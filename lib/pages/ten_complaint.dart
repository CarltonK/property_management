import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantComplain extends StatelessWidget {
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
                  gradient: LinearGradient(colors: [
                Colors.indigo,
                Colors.indigo[700],
                Colors.indigo[900]
              ], begin: Alignment.topCenter, end: Alignment.bottomRight)),
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
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: _createComplaintWidget(context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'My complaints',
                        style: GoogleFonts.muli(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _listHolder(context)
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

Widget _singleChildComplaint() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.grey[100],
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      subtitle: Text(
        '12 Jan 2020',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500)),
      ),
      title: Text(
        'Broken hinges',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Colors.red,
          ),
          onPressed: null),
    ),
  );
}

Widget _singleChildComplaint2() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.grey[100],
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      subtitle: Text(
        '31 Jan 2020',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500)),
      ),
      title: Text(
        'Faulty tap',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.done_all,
            color: Colors.green,
          ),
          onPressed: null),
    ),
  );
}

Widget _listHolder(BuildContext context) {
  return Center(
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white24)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.indigo[700],
        ),
        child: ListWheelScrollView(
            //perspective: 0.001,
            diameterRatio: 2,
            offAxisFraction: 0.1,
            itemExtent: 80,
            children: [
              _singleChildComplaint(),
              _singleChildComplaint2(),
              _singleChildComplaint(),
              _singleChildComplaint2()
            ]),
      ),
    ),
  );
}

Widget _createComplaintWidget(BuildContext context) {
  return Card(
    elevation: 30,
    margin: EdgeInsets.symmetric(horizontal: 60),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(30)),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.indigo[700]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            elevation: 10,
            splashColor: Colors.indigo,
            onPressed: () {
              print('I want to add a new complaint');
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: Colors.indigo[800],
              size: 30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Add New',
            style: GoogleFonts.muli(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5)),
          )
        ],
      ),
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
          'Complaints',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
        ),
      ],
    ),
  );
}
