import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/breakdown_widget.dart';
import 'package:property_management/widgets/tenant_popup.dart';

class OwnerHome extends StatefulWidget {
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  static Map<String, dynamic> data;

  Widget _ownerQuickGlance() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white54, width: 1.2)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.green[800], borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Amount Due: ',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                Text(
                  'KES 400,000',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Amount Received: ',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                Text(
                  'KES 320,000',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          'Kejani',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                CupertinoIcons.ellipsis,
                color: Colors.white,
              ),
              onPressed: () {
                //This filter selects the appropriate month
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                        title: Text(
                          'Select the month',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          )),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {},
                              child: Text(
                                'January 2020',
                                style: GoogleFonts.quicksand(fontSize: 20),
                              )),
                          FlatButton(
                              onPressed: () {},
                              child: Text(
                                'February 2020',
                                style: GoogleFonts.quicksand(fontSize: 20),
                              ))
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
                                      color: Colors.red, fontSize: 25)),
                            )));
                  },
                );
              })
        ],
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
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Summary',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    _ownerQuickGlance(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Breakdown',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            TenantPopup(apartment_name: data["apartment_name"],code: data["landlord_code"],)
          ],
        ),
      ),
    );
  }
}
