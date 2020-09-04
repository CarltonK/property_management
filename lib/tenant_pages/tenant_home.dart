import 'dart:async';
import 'dart:io';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:property_management/models/paymentmodel.dart';

class TenantHome extends StatefulWidget {
  @override
  _TenantHomeState createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  Map<String, dynamic> user;
  int _code;
  String uid, file_path, url_result;
  int _floor;
  String phone, natId, rent;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  static var date = DateTime.now();
  static var formatter = new DateFormat('yMMM');
  String dateFormatted = formatter.format(date);

  StorageUploadTask storageUploadTask;
  StorageTaskSnapshot taskSnapshot;

  /// Active image file
  File _imageFile;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (selected != null) {
      setState(() {
        _imageFile = selected;
      });
      _addBankPayment();
    }
  }

  /// Starts an upload task
  Future<String> _startUpload(File file) async {
    /// Unique file name for the file
    file_path = 'payments/$_code/$uid/$dateFormatted/$date/bankslip.png';
    //Create a storage reference
    StorageReference reference =
        FirebaseStorage.instance.ref().child(file_path);
    //Create a task that will handle the upload
    storageUploadTask = reference.putFile(
      file,
    );
    //Snapshot of the completed result
    taskSnapshot = await storageUploadTask.onComplete;
    url_result = await taskSnapshot.ref.getDownloadURL();
    //print('URL is $url_result');
    return url_result;
  }

  Future _addBankPayment() async {
    //Action sheet to show upload status
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            'Uploading',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            )),
          ),
          message: SpinKitDualRing(
            color: Colors.red,
            size: 50,
          ),
        );
      },
    );

    _startUpload(_imageFile).then((value) async {
      //Change value in firebase users collection

      await Firestore.instance
          .collection("payments")
          .document(_code.toString())
          .collection("received")
          .document()
          .setData({
        "url": value,
        "fullName": user["fullName"],
        "mode": "bank",
        "code": _code.toString(),
        "approved": false,
        "uid": uid,
        "date": date,
      });

      final String _collectionUpper = "apartments";
      final String _collectionMiddle = "floors";
      final String _collectionLower = "tenants";
      await Firestore.instance
          .collection(_collectionUpper)
          .document(_code.toString())
          .collection(_collectionMiddle)
          .document(_floor.toString())
          .collection(_collectionLower)
          .document(uid)
          .updateData({"paid": true});
    }).whenComplete(
      () {
        Navigator.of(context).pop();
        //Show a success message
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(
                'Your slip was uploaded successfully',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                )),
              ),
            );
          },
        );
      },
    ).catchError(
      (error) {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(
                error.toString(),
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                )),
              ),
            );
          },
        );
      },
    );
  }

  void _mpesaPay() {
    if (_code == 0) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Please wait for the landlord to approve your application',
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
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      print('I want to pay via M-PESA');
      if (phone == null && natId == null) {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(
                'Please complete your profile',
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
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            );
          },
        );
      } else {
        _lipaNaMpesa(phone, natId, int.parse(rent)).whenComplete(
          () {
            //Show a success message
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(
                    'Your M-PESA payment is being processed',
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
                    )),
                  ),
                );
              },
            );
          },
        ).catchError(
          (error) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(
                    error.toString(),
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    )),
                  ),
                );
              },
            );
          },
        );
      }
    }
  }

  Future _lipaNaMpesa(String phone, String id, int rent) async {
    await Firestore.instance
        .collection("payments")
        .document(_code.toString())
        .collection("received")
        .document()
        .setData({
      "fullName": user["fullName"],
      "mode": "M-PESA",
      "approved": false,
      "phone": phone,
      "code": _code.toString(),
      "natId": natId,
      "amount": rent,
      "uid": uid,
      "date": date,
    });

    //Update Floor Tile(Owner Home)
    final String _collectionUpper = "apartments";
    final String _collectionMiddle = "floors";
    final String _collectionLower = "tenants";
    await Firestore.instance
        .collection(_collectionUpper)
        .document(_code.toString())
        .collection(_collectionMiddle)
        .document(_floor.toString())
        .collection(_collectionLower)
        .document(uid)
        .updateData({"paid": true});
  }

  void _bankPay() {
    if (_code == 0) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Please wait for the landlord to approve your application',
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
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      );
    } else {
      //print('I want to upload a bank slip');
      _pickImage(ImageSource.camera);
    }
  }

//  Future _getMessagesCount() async {
//    QuerySnapshot query = await Firestore.instance.collection("apartments").document(_code.toString()).collection("announcements").getDocuments();
//    setState(() {
//      notificationCount = query.documents.length;
//    });
//    print(query.documents[0].data.toString());
//    return query.documents.length;
//  }

  Future showMessagePopup(Map<String, dynamic> message) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            '${message["notification"]["title"]}',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          content: Text(
            '${message["notification"]["body"]}',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: GoogleFonts.muli(
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    //_getMessagesCount();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        showMessagePopup(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.of(context).pushNamed('/announcement', arguments: _code);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.of(context).pushNamed('/announcement', arguments: _code);
      },
    );
  }

//  Future<List<DocumentSnapshot>> _getPayments(String uid) async {
//    //This is the name of the collection containing complaints
//    final String _collection = 'users';
//    //Create a variable to store Firestore instance
//    final Firestore _fireStore = Firestore.instance;
//    QuerySnapshot query = await _fireStore
//        .collection(_collection)
//        .document(uid)
//        .collection("payments_history")
//        .orderBy("date", descending: true)
//        .getDocuments();
//    print('Here are the documents ${query.documents}');
//    return query.documents;
//  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/tenant-profile', arguments: user);
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
          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.mail,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/announcement', arguments: _code);
          },
        )
      ],
    );
  }

  Widget showError(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget paymentCard(DocumentSnapshot map, String dateFormatted,
      String durationTaken, var difference) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.green[900],
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(8)),
      child: map["mode"] != "bank"
          ? ListTile(
              isThreeLine: true,
              title: Text(
                '$dateFormatted',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Paid via: ${map["mode"]}',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  ),
                  Text(
                    '$difference days $durationTaken',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  )
                ],
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Status',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Icon(
                    map["approved"] ? Icons.done_outline : Icons.cancel,
                    color: map["approved"] ? Colors.white : Colors.red,
                  )
                ],
              ),
            )
          : ExpansionTile(
              title: Text(
                '$dateFormatted',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
              ),
              subtitle: Text(
                'Paid via: ${map["mode"]}',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$difference days $durationTaken',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(
                        map["url"],
                        fit: BoxFit.fitWidth,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                )
              ],
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Status',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Icon(
                    map["approved"] ? Icons.done_outline : Icons.cancel,
                    color: map["approved"] ? Colors.white : Colors.red,
                  )
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    _floor = user['floorNumber'];
    _code = user["landlord_code"];
    phone = user["phone"];
    natId = user["natId"];
    rent = user["rent"];
    uid = user["uid"];

    return Scaffold(
      appBar: appBar(),
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Payments',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("payments")
                          .document(_code.toString())
                          .collection("received")
                          .where("uid", isEqualTo: uid)
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print('Snapshot Error: ${snapshot.error.toString()}');
                          return showError(
                              'Ooops! You need a code from your landlord to view your previous payments');
                        }
                        if (snapshot.data == null) {
                          return showError('You have no previous payments');
                        }
                        if (snapshot.data.documents.length == 0) {
                          return showError('You have no previous payments');
                        }
                        if (snapshot.hasData) {
                          return ListView(
                            children: snapshot.data.documents.map((map) {
                              var date = map["date"];
                              var formatter = new DateFormat('yMMMd');
                              String dateFormatted =
                                  formatter.format(date.toDate());

                              //Difference in days
                              DateTime dateDue = user["due"].toDate();
                              DateTime datePaid = map["date"].toDate();
                              var difference = dateDue.day - datePaid.day;
                              //print(difference);

                              dynamic durationTaken = "early";

                              if (difference < 0) {
                                difference = difference.abs();
                                durationTaken = "late";
                              } else {
                                durationTaken = "early";
                              }

                              return paymentCard(map, dateFormatted,
                                  durationTaken, difference);
                            }).toList(),
                          );
                        }
                        return Center(
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 150.0,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _code != 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MaterialButton(
                  padding: EdgeInsets.all(6),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  splashColor: Colors.greenAccent[700],
                  onPressed: _bankPay,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.add_a_photo,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Upload bank slip',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // MaterialButton(
                //   padding: EdgeInsets.all(6),
                //   color: Colors.white,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8)),
                //   splashColor: Colors.greenAccent[700],
                //   onPressed: _mpesaPay,
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: <Widget>[
                //       Icon(
                //         Icons.send,
                //         size: 20,
                //       ),
                //       SizedBox(
                //         width: 5,
                //       ),
                //       Text(
                //         'Lipa na M-PESA',
                //         style: GoogleFonts.quicksand(
                //             textStyle: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //         )),
                //       )
                //     ],
                //   ),
                // )
              ],
            )
          : Text(''),
    );
  }

//  void _eventSetter(DateTime setDate) {
//    setDate = _setDate.add(Duration(days: 30));
//    final Event event = Event(
//        title: 'Rent reminder',
//        description: 'I want to pay my rent on this day',
//        startDate: setDate,
//        endDate: setDate,
//        allDay: true);
//
//    Add2Calendar.addEvent2Cal(event).catchError((error) {
//      showDialog(
//          context: context,
//          child: CupertinoAlertDialog(
//            content: Text(
//              'We encountered an error when setting your reminder. Please try again',
//              style: GoogleFonts.quicksand(
//                  textStyle: TextStyle(
//                color: Colors.black,
//                fontSize: 20,
//              )),
//            ),
//          ));
//    })
//     .whenComplete(() {
//       showDialog(
//           context: context,
//           child: CupertinoAlertDialog(
//             content: Text(
//               'Redirecting you to your calendar',
//               style: GoogleFonts.quicksand(
//                   textStyle: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//               )),
//             ),
//           ));
//     });
//  }
}
//
//Widget _landlordDetails(BuildContext context) {
//  return Container(
//    //This container shows the landlord details
//    width: MediaQuery.of(context).size.width,
//    decoration: BoxDecoration(
//        color: Colors.green[900],
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(40), topRight: Radius.circular(40))),
//    padding: EdgeInsets.all(30),
//    child: Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Text(
//          'Landlord Information',
//          style: GoogleFonts.muli(
//              textStyle: TextStyle(
//                  color: Colors.white, fontSize: 22, letterSpacing: .5)),
//        ),
//        SizedBox(
//          height: 20,
//        ),
//        Row(
//          children: <Widget>[
//            CircleAvatar(
//              radius: 45,
//              backgroundColor: Colors.white,
//            ),
//            SizedBox(
//              width: 15,
//            ),
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Text(
//                  'Stannis Baratheon',
//                  style: GoogleFonts.muli(
//                      textStyle: TextStyle(
//                          color: Colors.white,
//                          fontSize: 20,
//                          fontWeight: FontWeight.bold,
//                          letterSpacing: .5)),
//                ),
//                SizedBox(
//                  height: 10,
//                ),
//                Text(
//                  'stannisbarry@gmail.com',
//                  style: GoogleFonts.muli(
//                      textStyle: TextStyle(
//                          color: Colors.white,
//                          fontSize: 16,
//                          letterSpacing: .5)),
//                ),
//              ],
//            )
//          ],
//        ),
//        SizedBox(
//          height: 30,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            MaterialButton(
//              color: Colors.white,
//              onPressed: () {
//                print('I want to call the landlord');
//              },
//              minWidth: MediaQuery.of(context).size.width * 0.35,
//              padding: EdgeInsets.all(16),
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(8)),
//              child: Text(
//                'Call',
//                style: GoogleFonts.quicksand(
//                    textStyle: TextStyle(
//                        color: Colors.indigo[900],
//                        fontSize: 18,
//                        fontWeight: FontWeight.bold,
//                        letterSpacing: .5)),
//              ),
//            ),
//            MaterialButton(
//              color: Colors.indigo[900],
//              onPressed: () {
//                print('I want to send an sms to the landlord');
//              },
//              minWidth: MediaQuery.of(context).size.width * 0.35,
//              padding: EdgeInsets.all(16),
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(8),
//                  side: BorderSide(color: Colors.white)),
//              child: Text(
//                'Send SMS',
//                style: GoogleFonts.quicksand(
//                    textStyle: TextStyle(
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        letterSpacing: .5)),
//              ),
//            )
//          ],
//        )
//      ],
//    ),
//  );
//}
