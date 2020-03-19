import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/breakdown_widget.dart';
import 'package:property_management/widgets/tenant_popup.dart';

class ManagerHome extends StatefulWidget {
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  static Map<String, dynamic> data;
  int code;

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
    code = data["landlord_code"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/manager-prof', arguments: data);
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tenants',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
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
                  )
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
      floatingActionButton: MaterialButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        splashColor: Colors.greenAccent[700],
        onPressed: () {
          Navigator.of(context).pushNamed('/record-cash', arguments: code);
        },
        child: Text(
          'Cash payment',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
    );
  }
}
