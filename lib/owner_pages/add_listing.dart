import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_management/services/location.dart';
import 'package:property_management/services/permission_handle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddListing extends StatefulWidget {
  @override
  _AddListingState createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
//  final FirebaseStorage _storage =
//      FirebaseStorage(storageBucket: 'gs://property-moha.appspot.com/');
//  StorageUploadTask _uploadTask;
//
//  PermissionService _permissionsService = PermissionService();
////  Locate _locatioN = Locate();
////
  Map<String, dynamic> data;
  Map<String, dynamic> coordinates;

  String apartment_name;
  int landlord_code;
  bool _uploaded = false;

  bool isLoading = true;
  dynamic result;
  bool callResponse = false;

  final _formKey = GlobalKey<FormState>();

  final _focusdescription = FocusNode();

  String _description;
  double _bedroomCount = 1;
  double _price;

  /// Active image file
  File _imageFile;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
    _uploaded = true;
  }

//  Future<Map> coordFuture() async {
//    coordinates = await _locatioN.getCoordinates();
//    print('$coordinates');
//  }

  @override
  void initState() {
    super.initState();
//    //Initiate the permissions request
//    _permissionsService.requestallPermissions();
//    coordFuture();
  }

  void _descHandler(String value) {
    _description = value.trim();
    print('Description: $_description');
  }

  void _priceHandler(String value) {
    _price = double.parse(value.trim());
    print('Price: $_price');
  }

  Widget _addPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Price',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: .2,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          autofocus: false,
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
//              labelText: 'Rent per month',
//              labelStyle: GoogleFonts.quicksand(
//                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.attach_money,
                color: Colors.white,
              )),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'The price is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusdescription);
          },
          textInputAction: TextInputAction.next,
          onSaved: _priceHandler,
        )
      ],
    );
  }

  Widget _addDesc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Description',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: .2,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          focusNode: _focusdescription,
          autofocus: false,
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(color: Colors.white, fontSize: 18)),
          decoration: InputDecoration(
              errorStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(16)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
//              labelText: 'A few words about the apartment',
//              labelStyle: GoogleFonts.quicksand(
//                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              )),
          maxLines: 3,
          keyboardType: TextInputType.text,
          validator: (value) {
            return null;
          },
          textInputAction: TextInputAction.done,
          onSaved: _descHandler,
        )
      ],
    );
  }

  Future saveToFirestore(String url) async {
    String _collectionName = "listings";
    await Firestore.instance.collection(_collectionName).document().setData({
      "name": apartment_name,
      "description": _description,
      "price": _price,
      "landlord_code": landlord_code,
      "bedrooms": _bedroomCount.toInt(),
      "url": url,
    });
  }

  String filePath;
  String url_result;

  /// Starts an upload task
  Future<String> _startUpload(File file) async {
    /// Unique file name for the file
    filePath =
        'images/${landlord_code.toString()}/${DateTime.now()}/coverPic.png';
    //Create a storage reference
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    //Create a task that will handle the upload
    StorageUploadTask storageUploadTask = reference.putFile(
      file,
    );
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    url_result = await taskSnapshot.ref.getDownloadURL();
    print('URL is $url_result');
    return url_result;
  }

  void _submitBtnPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('Bedrooms: ${_bedroomCount.toInt()}');
      //Display the Circular Loading Indicator
      setState(() {
        isLoading = false;
      });
      //First save the image file to cloud storage (if image is available)
      //Then retrieve the url and save to firestore
      if (_imageFile != null) {
        //Save to cloud storage
        _startUpload(_imageFile).then((value) {
          //Save to firestore with response of start upload
          saveToFirestore(value).whenComplete(() {
            //Show an action sheet with error
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                    title: Text(
                      'You have added a listing',
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
                          style: GoogleFonts.muli(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        )));
              },
            );
            //Disable the circular progress dialog
            setState(() {
              isLoading = true;
            });
            //Timed Function
            Timer(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          });
        });
      } else {
        saveToFirestore('').catchError((error) {
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
          //Show an action sheet with error
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                  title: Text(
                    'You have added a listing',
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
                        style: GoogleFonts.muli(
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      )));
            },
          );
          //Disable the circular progress dialog
          setState(() {
            isLoading = true;
          });
          //Timed Function
          Timer(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        });
      }
    }
  }

  Widget _registerBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
              color: Colors.white,
              onPressed: _submitBtnPressed,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'ADD LISTING',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.green[900],
                        fontSize: 20,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold)),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 3,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Retrieve data
    data = ModalRoute.of(context).settings.arguments;
    //Assign name and code
    apartment_name = data["apartment_name"];
    landlord_code = data["landlord_code"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text(
          'Kejani',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.green[900],
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: _uploaded ? 300 : 200,
                          child: _imageFile == null
                              ? Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      showCupertinoModalPopup(
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
                                                )),
                                              ),
                                              actions: <Widget>[
                                                CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _pickImage(
                                                          ImageSource.camera);
                                                    },
                                                    child: Text(
                                                      'CAMERA',
                                                      style: GoogleFonts.muli(
                                                          textStyle: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    )),
                                                CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _pickImage(
                                                          ImageSource.gallery);
                                                    },
                                                    child: Text(
                                                      'GALLERY',
                                                      style: GoogleFonts.muli(
                                                          textStyle: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ))
                                              ],
                                              cancelButton:
                                                  CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      },
                                                      child: Text(
                                                        'CANCEL',
                                                        style: GoogleFonts.muli(
                                                            textStyle: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )));
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                          size: 100,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Add a photo',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.file(
                                  _imageFile,
                                  fit: BoxFit.fill,
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                )),
                        ),
                        Text(
                          'Bedrooms',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _bedroomCount.toInt() == 0
                                      ? 'Bedsitter'
                                      : '${_bedroomCount.toInt()}',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontSize: _bedroomCount.toInt() == 0
                                              ? 30
                                              : 35,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      '0',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Slider.adaptive(
                                        min: 0,
                                        max: 5,
                                        divisions: 5,
                                        value: _bedroomCount,
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.white,
                                        onChanged: (value) {
                                          setState(() {
                                            _bedroomCount = value;
                                          });
                                        }),
                                    Text(
                                      '5',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _addPrice(),
                        SizedBox(
                          height: 20,
                        ),
                        _addDesc(),
                        SizedBox(
                          height: 20,
                        ),
                        _registerBtn()
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
