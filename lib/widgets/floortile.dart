import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FloorTile extends StatefulWidget {
  final int code;
  final int floor;
  FloorTile({Key key, @required this.code, @required this.floor})
      : super(key: key);

  @override
  _FloorTileState createState() => _FloorTileState();
}

class _FloorTileState extends State<FloorTile> {
  Future<List<DocumentSnapshot>> _getFloors(int code, int floor) async {
    final String _collectionUpper = "apartments";
    final String _collectionMiddle = "floors";
    final String _collectionLower = "tenants";

    QuerySnapshot query = await Firestore.instance
        .collection(_collectionUpper)
        .document(code.toString())
        .collection(_collectionMiddle)
        .document(floor.toString())
        .collection(_collectionLower)
        .orderBy("hseNumber")
        .getDocuments();
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: FutureBuilder(
              future: _getFloors(widget.code, widget.floor),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.hasError) {}
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.data.length == 0) {
                      return Center(
                        child: Text(
                          'This floor has no occupants',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                              textStyle:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      );
                    }
                    return ListView(
                      children: snapshot.data.map((map) {
                        //Date Parsing and Formatting
                        var dateRetrieved = map["due"];
                        var formatter = new DateFormat('d');
                        String date = formatter.format(dateRetrieved.toDate());

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          color: Colors.green[700],
                          child: GestureDetector(
                            onTap: () {
                              print(map["due"].runtimeType);
                            },
                            child: ListTile(
                              title: Text(
                                '${map["name"]}',
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                              subtitle: Text(
                                'Due: $date',
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(color: Colors.white)),
                              ),
                              leading: Text(
                                '${map["hseNumber"]}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Amount',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                  Text(
                                    '${map["rent"]}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
              }),
        ),
      ],
    );
  }
}
