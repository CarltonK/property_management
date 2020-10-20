import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/models/usermodel.dart';

class TenantProfile extends StatefulWidget {
  @override
  _TenantProfileState createState() => _TenantProfileState();
}

class _TenantProfileState extends State<TenantProfile> {
  final picker = ImagePicker();
  String _phone, _natId;
  String uid, filePath, urlResult;
  Map<String, dynamic> user;
  final _formKey = GlobalKey<FormState>();
  double remaining;

  StorageUploadTask storageUploadTask;
  StorageTaskSnapshot taskSnapshot;

  final _focusnatid = FocusNode();

  void _natIdHandler(String value) {
    _natId = value.trim();
    print('National ID: $_natId');
  }

  void _phoneHandler(String value) {
    _phone = value.trim();
    print('Phone: $_phone');
  }

  Widget _registerPhone(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black, fontSize: 18)),
      decoration: InputDecoration(
          errorStyle: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.black),
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5)),
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          labelText: 'Phone Number',
          labelStyle:
              GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.black)),
          icon: Icon(
            Icons.phone,
            color: Colors.black,
          )),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value.isEmpty) {
          return 'Phone is required';
        }
        if (value.length != 10) {
          return 'Phone number should be 10 digits';
        }
        if (!value.startsWith("07")) {
          return 'Phone number should start with "O7"';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_focusnatid);
      },
      textInputAction: TextInputAction.next,
      onSaved: _phoneHandler,
    );
  }

  Widget _registerID(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.black, fontSize: 18)),
      focusNode: _focusnatid,
      decoration: InputDecoration(
          errorStyle: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.black),
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5)),
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          labelText: 'ID Number',
          labelStyle:
              GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.black)),
          icon: Icon(
            Icons.perm_identity,
            color: Colors.black,
          )),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'ID number is required';
        }
        if (value.length < 7 || value.length > 8) {
          return 'ID number should be 8 digits';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.done,
      onSaved: _natIdHandler,
    );
  }

  bool isProfilePending = false;

  @override
  void initState() {
    super.initState();
  }

  /// Active image file
  File _imageFile;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final selected = await picker.getImage(source: source);
    if (selected != null) {
      setState(() {
        _imageFile = File(selected.path);
      });
      _changePic();
    }
  }

  /// Starts an upload task
  Future<String> _startUpload(File file) async {
    /// Unique file name for the file
    filePath = 'profiles/$uid/displayPic.png';
    //Create a storage reference
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    //Create a task that will handle the upload
    storageUploadTask = reference.putFile(
      file,
    );
    taskSnapshot = await storageUploadTask.onComplete;
    setState(() {
      remaining =
          (taskSnapshot.bytesTransferred / taskSnapshot.totalByteCount) * 100;
      print('remaining $remaining');
    });
    urlResult = await taskSnapshot.ref.getDownloadURL();
    print('URL is $urlResult');
    return urlResult;
  }

  Future _changePic() async {
    //Action sheet to show upload status
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Updating your profile',
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
        });

    _startUpload(_imageFile).then((value) {
      //Change value in firebase users collection
      Firestore.instance
          .collection("users")
          .document(uid)
          .updateData({"url": value});
    }).whenComplete(() {
      setState(() {
        user["url"] = urlResult;
      });

      Navigator.of(context).pop();
      //Show a success message
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(
                'Your profile has been updated',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                )),
              ),
            );
          });
    });
  }

  Future pictureSelection() {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            'Select a source',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
              child: Text(
                'CAMERA',
                style: GoogleFonts.muli(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
              child: Text(
                'GALLERY',
                style: GoogleFonts.muli(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget changePic() {
    return MaterialButton(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      splashColor: Colors.greenAccent[700],
      onPressed: () => pictureSelection(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.add_a_photo,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Change picture',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    //print('Data received in profile page $user');
    uid = user["uid"];

    //Date Parsing and Formatting
//    print('${user["registerDate"].runtimeType}');
    var dateTime = user["registerDate"].microsecondsSinceEpoch;
//    print('$dateTime');
    var parsedDate = new DateTime.fromMicrosecondsSinceEpoch(dateTime);
    var formatter = new DateFormat('yMMMd');
    String dateFormatted = formatter.format(parsedDate);

    //Prompt user to update their details

    if (user["phone"] == null) {
      isProfilePending = true;
    }
    print(isProfilePending);

    bool isLoading = true;
    dynamic result;
    bool callResponse = false;
    User _user;
    API _api = API();

    Future<bool> serverCall() async {
      result = await _api.completeProfile(_user, user["uid"]);
      print('This is the result: $result');

      if (result == null) {
        callResponse = false;
        return false;
      }
      callResponse = true;
      return true;
    }

    void _completeBtnPressed() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        _user = User(phone: _phone, natId: _natId);

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
                    ),
                  ),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).whenComplete(() {
          if (callResponse) {
            //print('Successful response ${result}');
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(
                    'Your profile has been updated',
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
            //Temporary changes
            user["phone"] = _phone;
            user["natId"] = _natId;

            //Disable the circular progress dialog
            setState(() {
              isLoading = true;
            });
            Timer(Duration(seconds: 2), () => Navigator.of(context).pop());
            Timer(Duration(seconds: 3), () => Navigator.of(context).pop());
          } else {
            //print('Failed response: ${result}');
            //Disable the circular progress dialog
            setState(() {
              isLoading = true;
            });
            //Show an action sheet with result
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(
                    'We have updated your profile',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              fontSize: 30,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[900],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Hero(
                      tag: 'tenant',
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: (MediaQuery.of(context).size.height * 0.25) / 2,
                        backgroundImage: user["url"] == null
                            ? null
                            : NetworkImage(user["url"]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${user["fullName"]}',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Text(
                    'Tenant since $dateFormatted',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isProfilePending
                      ? FlatButton(
                          onPressed: () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Complete your profile',
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                          color: Colors.greenAccent[700],
                                          width: 1.5),
                                    ),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            _registerPhone(context),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            _registerID(context)
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'SKIP',
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        color: Colors.red,
                                      ),
                                      isLoading
                                          ? FlatButton(
                                              onPressed: _completeBtnPressed,
                                              child: Text(
                                                'COMPLETE',
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
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
                          },
                          child: Text(
                            'Complete your profile',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          color: Colors.white,
                        )
                      : Text('')
                ],
              ),
            ),
          ])),
      floatingActionButton: changePic(),
    );
  }
}
