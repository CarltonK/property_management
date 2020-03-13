import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TenantPopup extends StatefulWidget {

  final String apartment_name;
  final int code;
  TenantPopup({Key key, @required this.apartment_name, @required this.code}) : super(key: key);
  @override
  _TenantPopupState createState() => _TenantPopupState();
}

class _TenantPopupState extends State<TenantPopup> {

  double opacity = 1;
  double padd = 100;
  bool hasDataQuery = false;

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

    query.documents.length != 0 ? hasDataQuery = true : false;

    return query.documents;
  }

  final _formKey = GlobalKey<FormState>();

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


  Future _updateFields(String docId, int code, String hseNumber,
      int floorNumber, String name) async {
    //Update users first
    await Firestore.instance
        .collection("users")
        .document(docId)
        .updateData({
      "landlord_code": code,
      "hseNumber": hseNumber,
      "approved": true,
      "floorNumber": floorNumber
    });

    await Firestore.instance.collection("tenants").document(docId).updateData({
      "landlord_code": code,
      "hseNumber": hseNumber,
      "approved": true,
      "floorNumber": floorNumber
    });

    await Firestore.instance
        .collection("apartments")
        .document(code.toString())
        .collection("floors")
        .document(floorNumber.toString())
        .setData({
      "floorNumber": floorNumber
    }
    );

    await Firestore.instance
        .collection("apartments")
        .document(code.toString())
        .collection("floors")
        .document(floorNumber.toString())
        .collection("tenants").document(docId).setData({
      "name": name,
      "uid":docId,
      "hseNumber":hseNumber,
    });

    setState(() {
      padd = MediaQuery.of(context).size.height * 0.5;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
            side: BorderSide(
              color: Colors.red[900],
              width: 2
            ),
            borderRadius: BorderRadius.circular(12)
          ),
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
                          builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'You have no tenant approval requests',
                                style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    )
                                ),),
                            );
                          }
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              if (snapshot.data.length == 0) {
                                setState(() {
                                  opacity = 0;
                                });
                                return Center(
                                  child: Text(
                                    'You have no tenant approval requests',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),),
                                );
                              }
                              else {
                                return ListView(
                                  children: snapshot.data.map((map) {
                                    //Date Parsing and Formatting
                                    var dateRetrieved = map["registerDate"];
                                    var formatter = new DateFormat('MMMd');
                                    String date =
                                    formatter.format(dateRetrieved.toDate());
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.green,
                                              width: 2
                                          ),
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          '${map["fullName"]}',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),),
                                        isThreeLine: true,
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${map["email"]}',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            Text(
                                              'Registered on $date',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            map["approved"] == null
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
                                                                        map.documentID;
                                                                    print(
                                                                        'The docId is: $docId');
                                                                    //Update necessary documents (tenants and users)
                                                                    _updateFields(
                                                                        docId,
                                                                        widget.code,
                                                                        _hseNumber,
                                                                        _floor,
                                                                        map["fullName"]
                                                                    );
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
                                                'APPROVE',style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            ): Text('')
                                          ],
                                        ),
                                        trailing: Column(
                                          children: <Widget>[
                                            Text(
                                              'Status',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            SizedBox(height: 5,),
                                            Icon(Icons.cancel, color: Colors.red,)
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
                              fontSize: 20
                            )
                          ),
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
