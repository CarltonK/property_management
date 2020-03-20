import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/breakdown_widget.dart';
import 'package:property_management/widgets/tenant_popup.dart';

class OwnerHome extends StatefulWidget {
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  static Map<String, dynamic> data;
  int code;

  Widget _ownerQuickGlance() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white54, width: 1.2)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.green[800], borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Amount Due: ',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                Text(
                  'KES 400,000',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Amount Received: ',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                Text(
                  'KES 320,000',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getFloors(int code) async {
    final String _collectionUpper = "apartments";
    final String _collectionLower = "floors";

    QuerySnapshot query = await Firestore.instance
        .collection(_collectionUpper)
        .document(code.toString())
        .collection(_collectionLower)
        .orderBy("floorNumber")
        .getDocuments();
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    //print('Owner data: $data');
    code = data["landlord_code"];
    //apartmentName = data["apartment"];

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
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.message,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
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
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Summary',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  _ownerQuickGlance(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Breakdown',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: FutureBuilder<List<DocumentSnapshot>>(
                          future: _getFloors(code),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasError) {
                              print(
                                  'Snapshot Error: ${snapshot.error.toString()}');
                              return Center(
                                  child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'There is an error ${snapshot.error.toString()}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                                  )
                                ],
                              ));
                            } else {
                              switch (snapshot.connectionState) {
                                case ConnectionState.done:
                                  if (snapshot.data.length == 0) {
                                    return Center(
                                      child: Text(
                                        'This apartment has no tenants',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 28,
                                                color: Colors.white)),
                                      ),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: Breakdown(
                                        snapshot: snapshot.data,
                                        code: code,
                                      )),
                                    ],
                                  );
                                  break;
                                case ConnectionState.waiting:
                                  return Center(
                                    child: SpinKitFadingCircle(
                                      size: 150,
                                      color: Colors.white,
                                    ),
                                  );
                                  break;
                                case ConnectionState.active:
                                  break;
                                case ConnectionState.none:
                                  break;
                              }
                              return Center(
                                child: SpinKitFadingCircle(
                                  size: 150,
                                  color: Colors.white,
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
            TenantPopup(
              apartment_name: data["apartment_name"],
              code: data["landlord_code"],
            )
          ],
        ),
      ),
    );
  }
}
