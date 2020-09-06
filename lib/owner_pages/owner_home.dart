import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/breakdown_widget.dart';
import 'package:property_management/widgets/tenant_popup.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';

class OwnerHome extends StatefulWidget {
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  static Map<String, dynamic> data;
  int code;
  String phone;
  String name;
  String uid;
  String apartmentName;

  // Widget _ownerQuickGlance() {
  //   return Card(
  //     elevation: 10,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         side: BorderSide(color: Colors.white54, width: 1.2)),
  //     child: Container(
  //       padding: EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //           color: Colors.green[800], borderRadius: BorderRadius.circular(12)),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 'Amount Due: ',
  //                 style: GoogleFonts.quicksand(
  //                     textStyle: TextStyle(color: Colors.white, fontSize: 16)),
  //               ),
  //               Text(
  //                 'KES 400,000',
  //                 style: GoogleFonts.quicksand(
  //                     textStyle: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold)),
  //               )
  //             ],
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 'Amount Received: ',
  //                 style: GoogleFonts.quicksand(
  //                     textStyle: TextStyle(color: Colors.white, fontSize: 16)),
  //               ),
  //               Text(
  //                 'KES 320,000',
  //                 style: GoogleFonts.quicksand(
  //                     textStyle: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold)),
  //               )
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  Future payAdmin(String phoneNumber, String userid) async {
    await Firestore.instance
        .collection("payments")
        .document('Admin')
        .collection('remittances')
        .document()
        .setData(
      {
        "phone": phoneNumber,
        "date": DateTime.now(),
        "uid": userid,
        "code": code,
      },
    );
  }

  Widget errorMessage(String message) {
    return Center(
      child: Text(
        message ?? '',
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Widget mainBody() {
    return Expanded(
      child: Container(
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _getFloors(code),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.hasError) {
              print(
                'Snapshot Error: ${snapshot.error.toString()}',
              );
              return errorMessage('This apartment has no tenants');
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.data.length == 0) {
                    return errorMessage('This apartment has no tenants');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Breakdown(
                          snapshot: snapshot.data,
                          code: code,
                        ),
                      ),
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
          },
        ),
      ),
    );
  }

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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      _getTenants(apartmentName).then((value) {
        if (value.length > 0) {
          promptPopup();
        }
      });
    });
  }

  Future promptPopup() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return TenantPopup(
          apartmentName: apartmentName,
          code: code,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print('Owner data: $data');
    code = data["landlord_code"];
    phone = data["phone"];
    uid = data['uid'];
    apartmentName = data['apartment_name'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              '/owner_prof',
              arguments: data,
            );
          },
          icon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          'Kejani',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.message,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/announcement',
                arguments: code,
              );
            },
          )
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            BackgroundColor(),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text(
                  //   'Summary',
                  //   style: GoogleFonts.quicksand(
                  //       textStyle: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold)),
                  // ),
                  // _ownerQuickGlance(),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Text(
                    'Tenants',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  mainBody(),
                ],
              ),
            ),
            // TenantPopup(
            //   apartmentName: data["apartment_name"],
            //   code: data["landlord_code"],
            // )
          ],
        ),
      ),
      floatingActionButton: MaterialButton(
        splashColor: Colors.greenAccent[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onPressed: () {
          payAdmin(phone, uid).whenComplete(
            () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    title: Text(
                      'Your booking request is being processed',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    message: Text(
                      'Please enter your M-PESA pin in the popup',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.monetization_on),
            SizedBox(
              width: 5,
            ),
            Text(
              'Pay',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
