import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class ViewListings extends StatefulWidget {
  @override
  _ViewListingsState createState() => _ViewListingsState();
}

class _ViewListingsState extends State<ViewListings> {
  Map<String, dynamic> data;

  int code;

  Future<List<DocumentSnapshot>> _getListings(int code) async {
    //This is the name of the collection containing listings
    final String _collection = 'listings';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .where("landlord_code", isEqualTo: code)
        .orderBy("price", descending: false)
        .getDocuments();
    print('How many: ${query.documents.length}');
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
        title: Text(
          'Listings',
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
              decoration: BoxDecoration(color: Colors.green[900]),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                  future: _getListings(code),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
//                    for (int i = 0; i<snapshot.data.length; i++) {
//                      print('Listing $i\n${snapshot.data[i].data}');
//                    }
                    if (snapshot.hasError) {
                      print('Snapshot Error: ${snapshot.error.toString()}');
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
                                'You have not created any listings',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontSize: 28, color: Colors.white)),
                              ),
                            );
                          }
                          return ListView(
                            children: snapshot.data
                                .map((map) => Card(
                                      elevation: 10,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        height: 200,
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              child: Container(
                                                child: Image.network(
                                                  map["url"],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                            Positioned(
                                                bottom: 10,
                                                left: 20,
                                                child: Opacity(
                                                  opacity: 0.75,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 10),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          'Bedrooms',
                                                          style: GoogleFonts.quicksand(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            '${map["bedrooms"]}',
                                                            style: GoogleFonts.quicksand(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)))
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                            Positioned(
                                                bottom: 10,
                                                right: 20,
                                                child: Opacity(
                                                  opacity: 0.75,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 10),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text('Price',
                                                            style: GoogleFonts.quicksand(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text('${map["price"]}',
                                                            style: GoogleFonts.quicksand(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)))
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                          break;
                        case ConnectionState.none:
                          break;
                        case ConnectionState.active:
                          break;
                        case ConnectionState.waiting:
                          return Center(
                            child: SpinKitFadingCircle(
                              size: 150,
                              color: Colors.white,
                            ),
                          );
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
          ],
        ),
      ),
      floatingActionButton: MaterialButton(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        splashColor: Colors.greenAccent[700],
        onPressed: () =>
            Navigator.of(context).pushNamed('/add-listing', arguments: data),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.create,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Create a listing',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            )
          ],
        ),
      ),
    );
  }
}
