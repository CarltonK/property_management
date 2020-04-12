import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerProf extends StatefulWidget {
  @override
  _OwnerProfState createState() => _OwnerProfState();
}

class _OwnerProfState extends State<OwnerProf> {
  static Map<String, dynamic> data;
  String uid;
  //Track list item selection
  bool isSelected = false;

  Future _buildLogOutSheet(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/owner_home', arguments: data);
  }

  Future<bool> _onWillPop() {
    return _buildLogOutSheet(context) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    //Retrieve data
    data = ModalRoute.of(context).settings.arguments;
    uid = data['uid'];
    //print('Retrieved data: $data');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          elevation: 0.0,
          title: Text(
            'Profile',
            style: GoogleFonts.quicksand(
                textStyle:
                    TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hello ${data["firstName"].split(' ')[0]}',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Here is a list of apartments you own',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Select one to activate it',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('apartments')
                              .where('owner', isEqualTo: data['firstName'])
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'You have not added any apartment',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              );
                            }
                            if (snapshot.data == null) {
                              return Center(
                                child: Text(
                                  'You have not added any apartment',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //Define keys
                                  var name = snapshot.data.documents[index]
                                      .data['apartment_name'];
                                  var docId =
                                      snapshot.data.documents[index].documentID;
                                  var loc = snapshot
                                      .data.documents[index].data['location'];
                                  var paybill = snapshot
                                      .data.documents[index].data['paybill'];

                                  isSelected = snapshot
                                      .data.documents[index].data['selected'];

                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: isSelected
                                            ? Colors.greenAccent[700]
                                            : Colors.transparent),
                                    width: MediaQuery.of(context).size.width,
                                    child: ListTile(
                                      isThreeLine: true,
                                      onTap: () async {
                                        //Code placeholder
                                        int code = snapshot
                                            .data
                                            .documents[index]
                                            .data['apartment_code'];
                                        print(code);
                                        String apartName = snapshot
                                            .data
                                            .documents[index]
                                            .data['apartment_name'];
                                        print(apartName);
                                        //Get all documents
                                        List<DocumentSnapshot> retrievedDocs =
                                            [];
                                        await Firestore.instance
                                            .collection('apartments')
                                            .getDocuments()
                                            .then((value) => retrievedDocs =
                                                value.documents);

                                        //Iterate through the list
                                        retrievedDocs.forEach((element) async {
                                          //Get selection status of each element
                                          bool status =
                                              element.data["selected"];

                                          //Update 'apartments' collection
                                          await Firestore.instance
                                              .collection('apartments')
                                              .document(element.documentID)
                                              .updateData(
                                                  {"selected": !status});
                                        });
                                        setState(() {
                                          snapshot.data.documents[index]
                                              .data["selected"] = !isSelected;
                                        });

                                        //Update landlord and user collection to new code and name
                                        await Firestore.instance
                                            .collection('landlords')
                                            .document(uid)
                                            .updateData({
                                          "apartment_name": apartName,
                                          "landlord_code": code
                                        });

                                        await Firestore.instance
                                            .collection('users')
                                            .document(uid)
                                            .updateData({
                                          "apartment_name": apartName,
                                          "landlord_code": code
                                        });

                                        //To make it realtime, we need to fetch the "users" collection again
                                        final String _collection = 'users';
                                        final Firestore _fireStore =
                                            Firestore.instance;
                                        var document = _fireStore
                                            .collection(_collection)
                                            .document(uid);
                                        var returnDoc = document.get();

                                        returnDoc.then((value) {
                                          //Return the data for user
                                          Map<String, dynamic> userData =
                                              value.data;
                                          Navigator.of(context).popAndPushNamed(
                                              '/owner_home',
                                              arguments: userData);
                                        });

                                        //Show a dialog prompting a user to login again to see the effects
                                        // showCupertinoModalPopup(
                                        //     context: context,
                                        //     builder: (BuildContext context) {
                                        //       return CupertinoActionSheet(
                                        //           title: Text(
                                        //             'Changes will not take effect until you login again',
                                        //             textAlign: TextAlign.center,
                                        //             style: GoogleFonts.quicksand(
                                        //                 textStyle: TextStyle(
                                        //                     color: Colors.black,
                                        //                     fontSize: 18,
                                        //                     fontWeight:
                                        //                         FontWeight.bold)),
                                        //           ),
                                        //           cancelButton:
                                        //               CupertinoActionSheetAction(
                                        //             onPressed: () =>
                                        //                 Navigator.of(context)
                                        //                     .pop(),
                                        //             child: Text(
                                        //               'DISMISS',
                                        //               textAlign: TextAlign.center,
                                        //               style: GoogleFonts.quicksand(
                                        //                   textStyle: TextStyle(
                                        //                       color: Colors.red,
                                        //                       fontWeight:
                                        //                           FontWeight
                                        //                               .bold)),
                                        //             ),
                                        //           ));
                                        //     });
                                      },
                                      title: Text(
                                        '$name',
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  title: Text(
                                                    'Are you sure ?',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Text(
                                                          'NO',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts.quicksand(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        )),
                                                    FlatButton(
                                                        onPressed: () async {
                                                          //Delete an apartment
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  'apartments')
                                                              .document(docId)
                                                              .delete();

                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'YES',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts.quicksand(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ))
                                                  ],
                                                );
                                              });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Delete',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Icon(Icons.delete,
                                                color: Colors.red)
                                          ],
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '$loc',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          Text(
                                            paybill == ''
                                                ? ''
                                                : 'Paybill: $paybill',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    color: Colors.white)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return SpinKitDoubleBounce(
                              color: Colors.white,
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: MaterialButton(
          splashColor: Colors.greenAccent[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          onPressed: () => Navigator.of(context)
              .pushNamed('/add-apartment', arguments: data),
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add),
              SizedBox(
                width: 5,
              ),
              Text(
                'Apartment',
                style: GoogleFonts.quicksand(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
