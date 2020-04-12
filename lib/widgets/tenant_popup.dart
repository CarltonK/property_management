import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TenantPopup extends StatefulWidget {
  final String apartment_name;
  final int code;
  TenantPopup({Key key, @required this.apartment_name, @required this.code})
      : super(key: key);
  @override
  _TenantPopupState createState() => _TenantPopupState();
}

class _TenantPopupState extends State<TenantPopup> {
  double opacity = 1;
  double padd = 130;
  bool hasDataQuery = true;

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
    print('How many: ${query.documents.length}');
    print('Docs: ${query.documents[0].data}');
    return query.documents;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: padd,
      bottom: padd,
      left: 20,
      right: 20,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 300),
        child: Card(
          elevation: 50,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red[900], width: 2),
              borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: FutureBuilder(
                      future: _getTenants(widget.apartment_name),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                        if (snapshot.hasError) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              padd = MediaQuery.of(context).size.height * 0.5;
                            });
                          });

                          return Center(
                            child: Text(
                              'You have no tenant approval requests',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            if (snapshot.data.length == 0) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  opacity = 0;
                                  hasDataQuery = false;
                                  padd =
                                      MediaQuery.of(context).size.height * 0.5;
                                });
                              });

                              return Center(
                                child: Text(
                                  'You have no tenant approval requests',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
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
                                        side: BorderSide(
                                            color: Colors.green, width: 2),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: ListTile(
                                      title: Text(
                                        '${map["fullName"]}',
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold)),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(
                                            'Registered on $date',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          map["approved"] == null
                                              ? FlatButton(
                                                  color: Colors.green[900],
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            '/tenant-verify',
                                                            arguments:
                                                                requiredData);
                                                  },
                                                  child: Text(
                                                    'APPROVE',
                                                    style: GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        onPressed: () {
                          setState(() {
                            padd = MediaQuery.of(context).size.height * 0.5;
                          });
                        },
                        child: Text(
                          'CANCEL',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
