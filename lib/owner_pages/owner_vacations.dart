import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';

class OwnerVacations extends StatefulWidget {
  final Widget appBar;
  OwnerVacations({@required this.appBar});

  @override
  _OwnerVacationsState createState() => _OwnerVacationsState();
}

class _OwnerVacationsState extends State<OwnerVacations> {
  Map<String, dynamic> data;
  Timestamp _date;
  int _code;

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    _date = data["date"];
    var formatter = new DateFormat('yMMMd');
    String dateFormatted = formatter.format(_date.toDate());

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          isThreeLine: true,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.home,
                color: Colors.black,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${data["hse"]}',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            '${data["name"]}',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Exit date - $dateFormatted',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                '${data["reason"]}',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget errorMessage(String message) {
    return Center(
      child: Text(
        message ?? '',
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Widget body() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("vacations")
          .where('landlord_code', isEqualTo: _code)
          .orderBy("date", descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return errorMessage(
            'You have not received any vacation requests',
          );
        }
        if (snapshot.data.documents.length == 0) {
          return errorMessage(
            'You have not received any vacation requests',
          );
        }
        if (snapshot.hasData) {
          return ListView(
            padding: const EdgeInsets.only(top: 10.0),
            children: snapshot.data.documents
                .map(
                  (data) => _buildListItem(context, data),
                )
                .toList(),
          );
        }
        return Center(
          child: SpinKitFadingCircle(
            size: 150,
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    _code = data["landlord_code"];
    //print('Vacations Page Data: $data');
    return Scaffold(
      appBar: widget.appBar,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            BackgroundColor(),
            Container(
              child: body(),
            )
          ],
        ),
      ),
    );
  }
}
