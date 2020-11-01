import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TenantPopup extends StatefulWidget {
  final String apartmentName;
  final int code;
  TenantPopup({Key key, @required this.apartmentName, @required this.code})
      : super(key: key);
  @override
  _TenantPopupState createState() => _TenantPopupState();
}

class _TenantPopupState extends State<TenantPopup> {
  Future<List<DocumentSnapshot>> _getTenants(String apartment) async {
    //This is the name of the collection containing tenants
    final String _collection = 'tenants';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .where("apartment_name", isEqualTo: apartment)
        .where("landlord_code", isEqualTo: 0)
        .getDocuments();
    //print('How many: ${query.documents.length}');
    //print('Docs: ${query.documents[0].data}');
    return query.documents;
  }

  Widget errorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 50,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.red[900], width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: Container(
              child: FutureBuilder(
                  future: _getTenants(widget.apartmentName),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (snapshot.hasError) {
                      return errorMessage(
                        'You have no tenant approval requests',
                      );
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        if (snapshot.data.length == 0) {
                          return errorMessage(
                            'You have no tenant approval requests',
                          );
                        } else {
                          return ListView(
                            children: snapshot.data.map((map) {
                              //Date Parsing and Formatting
                              var dateRetrieved = map["registerDate"];
                              var formatter = new DateFormat('MMMd');
                              String date =
                                  formatter.format(dateRetrieved.toDate());
                              //Placeholder map
                              Map<String, dynamic> requiredData = map.data;
                              requiredData["code"] = widget.code;
                              requiredData["docId"] = map.documentID;

                              return Card(
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.green, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${map["fullName"]}',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  isThreeLine: true,
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${map["email"]}',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Registered on $date',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      map["approved"] == null
                                          ? FlatButton(
                                              color: Colors.green[900],
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .popAndPushNamed(
                                                  '/tenant-verify',
                                                  arguments: requiredData,
                                                );
                                              },
                                              child: Text(
                                                'APPROVE',
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text('')
                                    ],
                                  ),
                                  trailing: Column(
                                    children: <Widget>[
                                      Text(
                                        'Status',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        break;
                      case ConnectionState.waiting:
                        return SpinKitFadingCircle(
                          color: Colors.green[900],
                          size: 100,
                        );
                        break;
                      case ConnectionState.none:
                        break;
                      case ConnectionState.active:
                        break;
                    }
                    return SpinKitFadingCircle(
                      color: Colors.green[900],
                      size: 100,
                    );
                  }),
            )),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
