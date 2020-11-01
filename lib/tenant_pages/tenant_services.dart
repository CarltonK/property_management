import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/models/serviceModel.dart';
import 'package:property_management/tenant_pages/services_list.dart';

class TenantSettings extends StatefulWidget {
  final Map<String, dynamic> data;
  TenantSettings({@required this.data});

  @override
  _TenantSettingsState createState() => _TenantSettingsState();
}

class _TenantSettingsState extends State<TenantSettings> {
  final _formKey = GlobalKey<FormState>();
  String uid;
  int codeData;
  Future<int> future;
  Map<String, dynamic> user;

  Widget _ownerCode() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white54,
          width: 1.2,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'This is your landlord code',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Code: ',
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  '${data["landlord_code"]}',
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> data;
  int code;
  String codeStr;

  Future<int> _getCode() async {
    return codeData;
  }

  void _codeHandler(String value) {
    codeStr = value.trim();
    code = int.parse(codeStr);
    print('Code: $code');
  }

  Widget _addCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Code',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: .2,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              helperText: 'This is the code given to you by your landlord',
              helperStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              labelText: 'Please enter the code',
              labelStyle: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.dialpad,
                color: Colors.white,
              )),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Code is required';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.done,
          onSaved: _codeHandler,
        )
      ],
    );
  }

  bool isLoading = true;
  dynamic result;
  var callResponse;

  Future<bool> serverCall() async {
    //Update relevant fields in relevant collections
    //The collections to be updated are "Tenants" and "Users"
    //This is the name of the collection
    final String _collectionUser = 'users';
    final String _collectionTenant = 'tenants';
    final String _collectionLandies = 'landlords';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;

    //See if any landlord has the code entered by the user
    QuerySnapshot query = await _fireStore
        .collection(_collectionLandies)
        .where('landlord_code', isEqualTo: code)
        .getDocuments();

    print('Here are the relevant docs: ${query.documents}');
    print('This is the count of the docs: ${query.documents.length}');

    //If length of documents = 0. No landlord has that code
    if (query.documents.length == 0) {
      callResponse = "Invalid code entered";
      return false;
    } else {
      //Update the users collection
      await _fireStore
          .collection(_collectionUser)
          .document(uid)
          .updateData({"landlord_code": code});
      //Update the tenants collection
      await _fireStore
          .collection(_collectionTenant)
          .document(uid)
          .updateData({"landlord_code": code});
      //Update the settings page map to reflect immediately
      data["landlord_code"] = code;
      //print('Updated data: $data');
      callResponse = true;
      return true;
    }
  }

  void _setCodeBtnPressed() {
    print('set code btn pressed');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = false;
      });

      serverCall().whenComplete(() {
        if (callResponse == true) {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                  title: Text(
                    'Your code has been accepted',
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
                            textStyle:
                                TextStyle(color: Colors.red, fontSize: 25)),
                      )));
            },
          );
          //Disable the circular progress dialog
          setState(() {
            isLoading = true;
          });
        } else {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                  title: Text(
                    'Invalid code entered',
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
                            textStyle:
                                TextStyle(color: Colors.red, fontSize: 25)),
                      )));
            },
          );
          //Disable the circular progress dialog
          setState(() {
            isLoading = true;
          });
        }
      });
    }
  }

  Widget _setCodeBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: isLoading
          ? RaisedButton(
              color: Colors.white,
              onPressed: _setCodeBtnPressed,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'SUBMIT',
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: Colors.green[900],
                        fontSize: 18,
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

  Widget _linkToLandlord() {
    //If the code is 0, prompt the user to enter the landlord code
    //Else the user can see the landlord code
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasError) {
          print('Snapshot Error: ${snapshot.error.toString()}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Ooops! ${snapshot.error.toString()}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent[700],
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            break;
          case ConnectionState.none:
            break;
          case ConnectionState.done:
            if (snapshot.data == 0) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Please request a code from your landlord',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _addCode(),
                      SizedBox(
                        height: 10,
                      ),
                      _setCodeBtn()
                    ],
                  ),
                ),
              );
            } else {
              return _ownerCode();
            }
            break;
          case ConnectionState.waiting:
            return Center(
                child: SpinKitFadingCircle(
              color: Colors.white,
              size: 150.0,
            ));
            break;
        }
        return Center(
            child: SpinKitFadingCircle(
          color: Colors.white,
          size: 150.0,
        ));
      },
    );
  }

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
          textStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    future = _getCode();
  }

  Widget singleServiceCard(ServiceModel service) {
    final String title = service.title.replaceFirst(
      service.title[0],
      service.title[0].toUpperCase(),
    );
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ServicesList(
            type: service.title,
            user: data,
          ),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.accessibility,
                size: 35,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title ?? '',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    data = ModalRoute.of(context).settings.arguments;
    // print('Services Page Data: $data');
    codeData = data["landlord_code"];
    uid = data["uid"];

    return Scaffold(
      appBar: appBar(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[900],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: appServices.length,
                itemBuilder: (context, index) {
                  ServiceModel singleService = appServices[index];
                  return singleServiceCard(singleService);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
