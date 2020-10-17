import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/breakdown_widget.dart';

class ViewTenants extends StatefulWidget {
  @override
  _ViewTenantsState createState() => _ViewTenantsState();
}

class _ViewTenantsState extends State<ViewTenants> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> data;

  int code;
  String apartmentName;
  String tenName;

  String _hseNumber;

  void _hseHandler(String value) {
    _hseNumber = value.trim();
    print('House Number: $_hseNumber');
  }

  int _floor;

  List<int> floors = <int>[0, 1, 2, 3, 4, 5];

  Widget _dropDownFloors(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: DropdownButton<int>(
              hint: Text(
                'Floor',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
              ),
              underline: Divider(
                color: Colors.black,
                height: 1,
                thickness: 1,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 30,
              ),
              items: floors.map((map) {
                return DropdownMenuItem<int>(
                    value: map,
                    child: Text('${map.toString()}',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))));
              }).toList(),
              isExpanded: true,
              value: _floor,
              onChanged: (value) {
                setState(() {
                  _floor = value;
                });
                print('Floor: $_floor');
              }),
        )
      ],
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
    code = data["code"];
    apartmentName = data["apartment"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Tenants',
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FutureBuilder<List<DocumentSnapshot>>(
                  future: _getFloors(code),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
            )
          ],
        ),
      ),
    );
  }
}
/*
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
                        case ConnectionState.active:
                          break;
                        case ConnectionState.done:
                          if (snapshot.data.length == 0) {
                            return Center(
                              child: Text(
                                'You have no tenants',
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontSize: 28, color: Colors.white)),
                              ),
                            );
                          }
                          return Container(
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var dataTemp = snapshot.data[index];
                                var _approved = dataTemp["approved"];
                                tenName = dataTemp["fullName"];
                                //Date Parsing and Formatting
                                var dateRetrieved = dataTemp["registerDate"];
                                var formatter = new DateFormat('MMMd');
                                String date =
                                    formatter.format(dateRetrieved.toDate());
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  margin: EdgeInsets.all(8),
                                  color: Colors.grey[100],
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[100]),
                                    width: MediaQuery.of(context).size.width,
                                    child: ListTile(
                                      dense: true,
                                      leading: _approved == null
                                          ? null
                                          : Text(
                                              '${dataTemp["hseNumber"]}',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                color: Colors.green[900],
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ),
                                      trailing: _approved == null
                                          ? Column(
                                              children: <Widget>[
                                                Text(
                                                  'Pending',
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Colors.green[900],
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Icon(Icons.cancel,
                                                    color: Colors.red),
                                              ],
                                            )
                                          : Icon(Icons.done,
                                              color: Colors.green[900]),
                                      title: Text(
                                        '${dataTemp["fullName"]}',
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                color: Colors.green[900],
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${dataTemp["apartment_name"]}',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          _approved == null
                                              ? FlatButton(
                                                  color: Colors.green[900],
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
                                                          'Assign house details',
                                                          style: GoogleFonts.quicksand(
                                                              textStyle: TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        content: Form(
                                                          key: _formKey,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
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
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              _dropDownFloors(
                                                                  context)
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              onPressed: () {
                                                                if (_floor ==
                                                                    null) {
                                                                  showCupertinoModalPopup(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return CupertinoActionSheet(
                                                                          title:
                                                                              Text(
                                                                            'You have not selected a floor number',
                                                                            style: GoogleFonts.quicksand(
                                                                                textStyle: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 20,
                                                                              color: Colors.black,
                                                                            )),
                                                                          ),
                                                                          cancelButton: CupertinoActionSheetAction(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                FocusScope.of(context).unfocus();
                                                                              },
                                                                              child: Text(
                                                                                'CANCEL',
                                                                                style: GoogleFonts.muli(textStyle: TextStyle(color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold)),
                                                                              )));
                                                                    },
                                                                  );
                                                                } else {
                                                                  if (_formKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    _formKey
                                                                        .currentState
                                                                        .save();
                                                                    //Get the docId which is the uid of the tenant
                                                                    String
                                                                        docId =
                                                                        snapshot
                                                                            .data[index]
                                                                            .documentID;
                                                                    print(
                                                                        'The docId is: $docId');
                                                                    //Update necessary documents (tenants and users)
                                                                    _updateFields(
                                                                        docId,
                                                                        code,
                                                                        _hseNumber,
                                                                        _floor,
                                                                        tenName);
                                                                    Future.delayed(
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                              child: Text(
                                                                'Assign'
                                                                    .toUpperCase(),
                                                                style: GoogleFonts.quicksand(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              )),
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                'Cancel'
                                                                    .toUpperCase(),
                                                                style: GoogleFonts.quicksand(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
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
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                )
                                              : Text('Member since $date',
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Colors.green[900],
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600)))
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
 */
