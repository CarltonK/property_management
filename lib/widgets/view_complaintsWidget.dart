import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ViewComplaintsWidget extends StatefulWidget {
  final int code;
  ViewComplaintsWidget({Key key, @required this.code}) : super(key: key);

  @override
  _ViewComplaintsWidgetState createState() => _ViewComplaintsWidgetState();
}

class _ViewComplaintsWidgetState extends State<ViewComplaintsWidget> {

  String docId;
  String uid;
  String message;
  final _formKey = GlobalKey<FormState>();

//  Future<List<DocumentSnapshot>> _getComplaints() async {
//    //This is the name of the collection containing complaints
//    final String _collection = 'complaints';
//    //Create a variable to store Firestore instance
//    final Firestore _fireStore = Firestore.instance;
//    QuerySnapshot query = await _fireStore
//        .collection(_collection)
//        .where('landlord_code', isEqualTo: widget.code)
//        .orderBy("date", descending: true)
//        .getDocuments();
//    // print('Here are the documents ${query.documents}');
//    return query.documents;
//  }

  void _messageHandler(String value) {
    message = value.trim();
    print('Message: $message');
  }

  Widget _addMessage(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black, fontSize: 18)),
      decoration: InputDecoration(
          errorStyle: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.black),
          ),
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5)),
          errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          labelText: 'Status of the issue',
          labelStyle:
          GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.black)),
          ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'A message is required';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.done,
      onSaved: _messageHandler,
    );
  }

  bool isLoading = true;

  void _replyComplaint() {

    showCupertinoModalPopup(
        context:
        context,
        builder:
            (BuildContext
        context) {
          return AlertDialog(
            title:
            Text(
              'Send a quick message',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  )),
            ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                      color: Colors.greenAccent[700],
                      width: 1.5)),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    _addMessage(context),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () =>
                    Navigator.of(context).pop(),
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18)),
                ),
                color: Colors.red,
              ),
              isLoading
              ? FlatButton(
                onPressed: _completeBtnPressed,
                child: Text(
                  'SEND',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18)),
                ),
                color: Colors.green,
              )
                  : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                ),
              )
            ],
          );
        });
  }

  Future serverCall() async {

    await Firestore.instance
        .collection("complaints")
        .document(docId)
        .updateData({
      "message": message
    });

  }

  void _completeBtnPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = false;
      });

      serverCall().catchError((error) {
        print('This is the error $error');
        //Disable the circular progress dialog
        setState(() {
          isLoading = true;
        });
        //Show an action sheet with error
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
                title: Text(
                  '$error',
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
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    )));
          },
        );
      }).whenComplete(() {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(
                'Your message has been sent',
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
        //Disable the circular progress dialog
        setState(() {
          isLoading = true;
        });
        Timer(Duration(seconds: 2), () => Navigator.of(context).pop());
        Timer(Duration(seconds: 3), () => Navigator.of(context).pop());
      });
    }
  }

  void _closeComplaint() async {

    await Firestore.instance
        .collection("complaints")
        .document(docId).updateData({
      "fixed":true
    });

    showCupertinoModalPopup(
        context:
        context,
        builder:
            (BuildContext
        context) {
          return CupertinoActionSheet(
            title:
            Text(
              'You have marked the issue as fixed',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: Firestore.instance
          .collection("complaints")
          .where("landlord_code",isEqualTo: widget.code)
          .orderBy("date", descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //There is an error loading the data
            if (snapshot.hasError) {
              print('Snapshot Error: ${snapshot.error.toString()}');
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Ooops! ${snapshot.error.toString()}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent[700],
                      fontSize: 20,
                    )),
                  )
                ],
              ));
            }
            if (snapshot.data == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'You have not received any complaints',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 25,
                        )),
                  ),
                  SizedBox(height: 10,),
                  SpinKitFadingCircle(
                    color: Colors.white,
                    size: 150.0,
                  )
                ],
              );
            }
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text(
                  'You have not received any complaints',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 25,
                      )),
                ),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var date = snapshot.data.documents[index].data['date'];
                  var tenant = snapshot.data.documents[index].data['tenant'];
                  var hse = snapshot.data.documents[index].data['hse'];
                  var title = snapshot.data.documents[index].data['title'];
                  var reply = snapshot.data.documents[index].data['message'];
                  bool fixed = snapshot.data.documents[index].data['fixed'];
                  docId = snapshot.data.documents[index].documentID;
                  uid = snapshot.data.documents[index].data["uid"];

                  //Date Parsing and Formatting
                  var parsedDate = DateTime.parse(date);
                  var formatter = new DateFormat('yMMMd');
                  String dateFormatted = formatter.format(parsedDate);
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            color: Colors.green[900],
                            size: 20,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$hse',
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$title',
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            '$dateFormatted',
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.w500)),
                          ),
                          reply == null
                          ? SizedBox(height: 1,)
                          : Text(
                            'Reply: $reply',
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          fixed == false
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                  color: Colors.red,
                                  onPressed: _replyComplaint,
                                  child: Text(
                                    'REPLY',
                                    style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  )),
                              FlatButton(
                                  color: Colors.green,
                                  onPressed: _closeComplaint,
                                  child: Text(
                                    'CLOSE',
                                    style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ))
                            ],
                          )
                              : Text('')
                        ],
                      ),
                      title: Text(
                        '$tenant',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold)),
                      ),
                      trailing: Column(
                        children: <Widget>[
                          Text(
                            'Done',
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            fixed ? Icons.done : Icons.cancel,
                            color: fixed ? Colors.green[900] : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
                child: SpinKitFadingCircle(
              color: Colors.white,
              size: 150.0,
            ));
          }),
    );
  }
}
