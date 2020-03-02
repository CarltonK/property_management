import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OwnerSettings extends StatelessWidget {
  static Map<String, dynamic> data;
  int code;
  String apartmentName;
  final _formKey = GlobalKey<FormState>();
  String _hseNumber;

  void _hseHandler(String value) {
    _hseNumber = value.trim();
    print('House Number: $_hseNumber');
  }

  Future _getTenants(String apartment) async {
    //This is the name of the collection containing tenants
    final String _collection = 'tenants';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .where("apartment_name", isEqualTo: apartment)
        .getDocuments();
    print('How many: ${query.documents.length}');
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print('Settings Page Data: $data');
    code = data["landlord_code"];
    apartmentName = data["apartment_name"];

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
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tenants',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: FutureBuilder(
                        future: _getTenants(apartmentName),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                              case ConnectionState.active:
                                break;
                              case ConnectionState.done:
                                return Container(
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var dataTemp = snapshot.data[index];
                                      var _approved = dataTemp["approved"];
                                      //Date Parsing and Formatting
                                      var dateRetrieved =
                                          dataTemp["registerDate"];
                                      var formatter = new DateFormat('MMMd');
                                      String date = formatter
                                          .format(dateRetrieved.toDate());

                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        margin: EdgeInsets.only(right: 8),
                                        color: Colors.grey[100],
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[100]),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: ListTile(
                                            dense: true,
                                            leading: _approved == null
                                                ? null
                                                : Text(
                                                    '${dataTemp["hseNumber"]}',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            textStyle:
                                                                TextStyle(
                                                      color: Colors.green[900],
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                  ),
                                            trailing: _approved == null
                                                ? Icon(Icons.cancel,
                                                    color: Colors.red)
                                                : Icon(Icons.done,
                                                    color: Colors.green[900]),
                                            title: Text(
                                              '${dataTemp["firstName"]} ${dataTemp["lastName"]}',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.green[900],
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${dataTemp["phone"]}',
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Colors.green[900],
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                                _approved == null
                                                    ? FlatButton(
                                                        color:
                                                            Colors.green[900],
                                                        onPressed: () {
                                                          showCupertinoModalPopup(
                                                            context: context,
                                                            builder: (_) =>
                                                                AlertDialog(
                                                              elevation: 20,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16)),
                                                              title: Text(
                                                                'Assign a house number',
                                                                style: GoogleFonts.quicksand(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                              content: Card(
                                                                child: Form(
                                                                  key: _formKey,
                                                                  child:
                                                                      TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    onSaved:
                                                                        _hseHandler,
                                                                    validator:
                                                                        (value) {
                                                                      if (value
                                                                          .isEmpty) {
                                                                        return 'This value is required';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.home,
                                                                              color: Colors.black,
                                                                            ),
                                                                            labelText:
                                                                                'Enter the house number'),
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .done,
                                                                    onFieldSubmitted:
                                                                        (value) {
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (_formKey
                                                                          .currentState
                                                                          .validate()) {
                                                                        _formKey
                                                                            .currentState
                                                                            .save();
                                                                        //Get the docId which is the uid of the tenant
                                                                        String docId = snapshot
                                                                            .data[index]
                                                                            .documentID;
                                                                        print(
                                                                            'The docId is: $docId');
                                                                        //Update necessary documents (tenants and users)
                                                                        _updateFields(
                                                                            docId,
                                                                            code,
                                                                            _hseNumber);
                                                                        Future.delayed(
                                                                            Duration(seconds: 2),
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      'Assign'
                                                                          .toUpperCase(),
                                                                      style: GoogleFonts.quicksand(
                                                                          textStyle: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                    )),
                                                                FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                      'Cancel'
                                                                          .toUpperCase(),
                                                                      style: GoogleFonts.quicksand(
                                                                          textStyle: TextStyle(
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ))
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          'Approve',
                                                          style: GoogleFonts.quicksand(
                                                              textStyle: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      )
                                                    : Text('Member since $date',
                                                        style: GoogleFonts.quicksand(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .green[900],
                                                                fontSize: 13,
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
                                );
                                break;
                              case ConnectionState.none:
                                break;
                              case ConnectionState.waiting:
                                return Center(
                                  child: SpinKitFadingCircle(
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                );
                                break;
                            }
                          }
                          return Center(
                            child: SpinKitFadingCircle(
                              size: 100,
                              color: Colors.white,
                            ),
                          );
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future _updateFields(String docId, int code, String hseNumber) async {
  //Update users first
  await Firestore.instance.collection("users").document(docId).updateData(
      {"landlord_code": code, "hseNumber": hseNumber, "approved": true});

  await Firestore.instance.collection("tenants").document(docId).updateData(
      {"landlord_code": code, "hseNumber": hseNumber, "approved": true});
}
