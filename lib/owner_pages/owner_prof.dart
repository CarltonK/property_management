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
  @override
  Widget build(BuildContext context) {
    //Retrieve data
    data = ModalRoute.of(context).settings.arguments;
    print('Retrieved data: $data');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Profile',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
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
                            fontSize: 18,
                            color: Colors.white)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Here is a list of apartments you own',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection('apartments')
                          .where('owner', isEqualTo: data['firstName'])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: snapshot.data.documents
                                .map((map) => Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white)),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: ListTile(
                                        isThreeLine: true,
                                        title: Text(
                                          '${map['apartment_name']}',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            showCupertinoModalPopup(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text(
                                                      'Are you sure ?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.quicksand(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                            textAlign: TextAlign
                                                                .center,
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
                                                                .document(map
                                                                    .documentID)
                                                                .delete();
                                                          },
                                                          child: Text(
                                                            'YES',
                                                            textAlign: TextAlign
                                                                .center,
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
                                                        color: Colors.white)),
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
                                              '${map['location']}',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            Text(
                                              'Paybill: ${map['paybill']}',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.white)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                        return SpinKitDoubleBounce(
                          color: Colors.white,
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MaterialButton(
        splashColor: Colors.greenAccent[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () {},
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
                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}
