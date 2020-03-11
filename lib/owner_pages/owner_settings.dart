import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_management/widgets/view_tenantsWidgets.dart';

class OwnerSettings extends StatefulWidget {
  static Map<String, dynamic> data;

  @override
  _OwnerSettingsState createState() => _OwnerSettingsState();
}

class _OwnerSettingsState extends State<OwnerSettings> {
  int code;

  String apartmentName;
  String tenName;

  Future _getManagers(String apartment) async {
    //This is the name of the collection containing managers
    final String _collection = 'managers';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .where("apartment_name", isEqualTo: apartment)
        .getDocuments();
    print('How many: ${query.documents.length}');
    return query.documents;
  }

  Future _getListings(int code) async {
    //This is the name of the collection containing listings
    final String _collection = 'listings';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .where("landlord_code", isEqualTo: code)
        .getDocuments();
    print('How many: ${query.documents.length}');
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    OwnerSettings.data = ModalRoute.of(context).settings.arguments;
    print('Settings Page Data: ${OwnerSettings.data}');
    code = OwnerSettings.data["landlord_code"];
    apartmentName = OwnerSettings.data["apartment_name"];

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
              decoration: BoxDecoration(color: Colors.green[900]),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('I want to view tenants');
                                  Navigator.of(context).pushNamed('/view-tenants',arguments: {
                                    "code": code,
                                    "apartment": apartmentName
                                  });
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.people,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Tenants',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('I want to view listings');
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_city,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Listings',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  Divider(
                    thickness: 1,
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Manager(s)',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                                future: _getManagers(apartmentName),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
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
                                  }
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      break;
                                    case ConnectionState.active:
                                      break;
                                    case ConnectionState.none:
                                      break;
                                    case ConnectionState.done:
                                      if (snapshot.data.length == 0) {
                                        return Expanded(
                                          child: Center(
                                            child: Text(
                                              'You have no managers',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        );
                                      }
                                      return Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var dataTemp =
                                                  snapshot.data[index];
                                              //Date Parsing and Formatting
                                              var dateRetrieved =
                                                  dataTemp["registerDate"];
                                              var formatter =
                                                  new DateFormat('MMMd');
                                              String date = formatter.format(
                                                  dateRetrieved.toDate());
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                margin:
                                                    EdgeInsets.only(right: 8),
                                                color: Colors.grey[100],
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.grey[100]),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListTile(
                                                    dense: true,
                                                    leading: Icon(
                                                        Icons.person_outline),
                                                    title: Text(
                                                      '${dataTemp["fullName"]}',
                                                      style: GoogleFonts.quicksand(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          '${dataTemp["phone"]}',
                                                          style: GoogleFonts.quicksand(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                          .green[
                                                                      900],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                        Text('Added on $date',
                                                            style: GoogleFonts.quicksand(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                            .green[
                                                                        900],
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                      break;
                                  }
                                  return Expanded(
                                    child: SpinKitFadingCircle(
                                      size: 120,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      )),
//                  Divider(
//                    thickness: 1,
//                  ),
//                  Text(
//                    'Listings',
//                    style: GoogleFonts.quicksand(
//                        textStyle: TextStyle(
//                            fontSize: 20,
//                            fontWeight: FontWeight.w500,
//                            color: Colors.white)),
//                  ),
//                  SizedBox(
//                    height: 10,
//                  ),
//                  Container(
//                    height: 70,
//                    width: double.infinity,
//                    child: FutureBuilder(
//                        future: _getListings(code),
//                        builder:
//                            (BuildContext context, AsyncSnapshot snapshot) {
//                          if (snapshot.hasError) {
//                            print(
//                                'Snapshot Error: ${snapshot.error.toString()}');
//                            return Center(
//                                child: Column(
//                              children: <Widget>[
//                                SizedBox(
//                                  height: 50,
//                                ),
//                                Text(
//                                  'There is an error ${snapshot.error.toString()}',
//                                  textAlign: TextAlign.center,
//                                  style: GoogleFonts.quicksand(
//                                      textStyle: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.white,
//                                    fontSize: 20,
//                                  )),
//                                )
//                              ],
//                            ));
//                          } else {
//                            switch (snapshot.connectionState) {
//                              case ConnectionState.active:
//                                break;
//                              case ConnectionState.done:
//                                return Container(
//                                  width: double.infinity,
//                                  child: ListView.builder(
//                                    scrollDirection: Axis.horizontal,
//                                    itemCount: snapshot.data.length,
//                                    itemBuilder:
//                                        (BuildContext context, int index) {
//                                      var dataTemp = snapshot.data[index];
//                                      return Card(
//                                        shape: RoundedRectangleBorder(
//                                            borderRadius:
//                                                BorderRadius.circular(12)),
//                                        margin: EdgeInsets.only(right: 8),
//                                        color: Colors.grey[100],
//                                        child: Container(
//                                          padding: EdgeInsets.all(4),
//                                          decoration: BoxDecoration(
//                                              borderRadius:
//                                                  BorderRadius.circular(10),
//                                              color: Colors.grey[100]),
//                                          width: MediaQuery.of(context)
//                                                  .size
//                                                  .width *
//                                              0.7,
//                                          child: ListTile(
//                                            dense: true,
//                                            leading: Icon(Icons.location_city),
//                                            title: Text(
//                                              '${dataTemp["location"]}',
//                                              style: GoogleFonts.quicksand(
//                                                  textStyle: TextStyle(
//                                                      color: Colors.green[900],
//                                                      fontWeight:
//                                                          FontWeight.bold)),
//                                            ),
//                                            subtitle: Column(
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.start,
//                                              children: <Widget>[
//                                                Text(
//                                                  '${dataTemp["price"]}',
//                                                  style: GoogleFonts.quicksand(
//                                                      textStyle: TextStyle(
//                                                          color:
//                                                              Colors.green[900],
//                                                          fontWeight:
//                                                              FontWeight.w600)),
//                                                ),
//                                                Text(
//                                                    '${dataTemp["bedrooms"]} bedrooms',
//                                                    style: GoogleFonts.quicksand(
//                                                        textStyle: TextStyle(
//                                                            color: Colors
//                                                                .green[900],
//                                                            fontSize: 13,
//                                                            fontWeight:
//                                                                FontWeight
//                                                                    .w600)))
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      );
//                                    },
//                                  ),
//                                );
//                                break;
//                              case ConnectionState.none:
//                                break;
//                              case ConnectionState.waiting:
//                                return Center(
//                                  child: SpinKitFadingCircle(
//                                    size: 100,
//                                    color: Colors.white,
//                                  ),
//                                );
//                                break;
//                            }
//                          }
//                          return Center(
//                            child: SpinKitFadingCircle(
//                              size: 100,
//                              color: Colors.white,
//                            ),
//                          );
//                        }),
//                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          MaterialButton(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            splashColor: Colors.greenAccent[700],
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/add-manager', arguments: OwnerSettings.data);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.person_add),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Add a manager',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )
              ],
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            splashColor: Colors.greenAccent[700],
            onPressed: () => Navigator.of(context)
                .pushNamed('/add-listing', arguments: OwnerSettings.data),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.create),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Create a listing',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
