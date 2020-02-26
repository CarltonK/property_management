import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantComplain extends StatelessWidget {
  Map<String, dynamic> tenantdata;
  @override
  Widget build(BuildContext context) {
    tenantdata = ModalRoute.of(context).settings.arguments;
    print('Complaints Page Data: $tenantdata');

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
                    _appBarLayout(context, tenantdata),
                    SizedBox(
                      height: 20,
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
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: ListTile(
      subtitle: Text(
        '12 Jan 2020',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500)),
      ),
      title: Text(
        'Broken hinges',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)),
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
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: ListTile(
      subtitle: Text(
        '31 Jan 2020',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500)),
      ),
      title: Text(
        'Faulty tap',
        style: GoogleFonts.quicksand(
            textStyle:
                TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)),
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
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green[900],
      ),
      child: ListView(
          //perspective: 0.001,
//          diameterRatio: 2,
//          offAxisFraction: 0.1,
          itemExtent: 80,
          children: [
            _singleChildComplaint(),
            _singleChildComplaint2(),
            _singleChildComplaint(),
            _singleChildComplaint2(),
            _singleChildComplaint(),
            _singleChildComplaint2(),
            _singleChildComplaint(),
            _singleChildComplaint2()
          ]),
    ),
  );
}

Widget _appBarLayout(BuildContext context, Map<String, dynamic> data) {
  //This custom appBar replaces the Flutter App Bar
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
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
        FloatingActionButton(
          elevation: 10,
          mini: false,
          splashColor: Colors.greenAccent[700],
          tooltip: 'Add a new complaint',
          onPressed: () {
            print('I want to add a new complaint');
            Navigator.of(context).pushNamed('/add-complaint', arguments: data);
          },
          backgroundColor: Colors.green[900],
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        )
      ],
    ),
  );
}
