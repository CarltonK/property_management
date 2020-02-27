import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/view_complaintsWidget.dart';

class OwnerComplaint extends StatefulWidget {
  @override
  _OwnerComplaintState createState() => _OwnerComplaintState();
}

class _OwnerComplaintState extends State<OwnerComplaint> {

  Widget _appBarLayout() {
    return Text(
      'Complaints received',
      style: GoogleFonts.quicksand(
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    print('Complaints Page Data: $data');

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green[900]
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBarLayout(),
                  SizedBox(
                    height: 20,
                  ),
                  ViewComplaintsWidget(code: data["landlord_code"])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
