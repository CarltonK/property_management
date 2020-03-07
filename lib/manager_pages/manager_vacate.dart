import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManagerVacate extends StatefulWidget {
  @override
  _ManagerVacateState createState() => _ManagerVacateState();
}

class _ManagerVacateState extends State<ManagerVacate> {

  Map<String, dynamic> data;
  Timestamp _date;
  int _code;

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    _date = data["date"];
    var formatter = new DateFormat('yMMMd');
    String dateFormatted = formatter.format(_date.toDate());

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          isThreeLine: true,
          leading: Column(
            children: <Widget>[
              Icon(
                Icons.home,
                color: Colors.green[900],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${data["hse"]}',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.green[900], fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          title: Text(
            '${data["name"]}',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.green[900], fontWeight: FontWeight.bold)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Exit date - $dateFormatted',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(color: Colors.green[900])),
              ),
              Text(
                '${data["reason"]}',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(color: Colors.green[900])),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    _code = data["landlord_code"];

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
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.green[900],
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("vacations")
                      .where('landlord_code', isEqualTo: _code)
                      .orderBy("date", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        padding: const EdgeInsets.only(top: 20.0),
                        children: snapshot.data.documents
                            .map((data) => _buildListItem(context, data))
                            .toList(),
                      );
                    }
                    return Center(
                      child: SpinKitFadingCircle(
                        size: 150,
                        color: Colors.white,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}