import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';
import 'package:property_management/widgets/view_complaintsWidget.dart';

class OwnerComplaint extends StatefulWidget {
  final Widget appBar;
  OwnerComplaint({@required this.appBar});
  @override
  _OwnerComplaintState createState() => _OwnerComplaintState();
}

class _OwnerComplaintState extends State<OwnerComplaint> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    //print('Complaints Page Data: $data');
    return Scaffold(
      appBar: widget.appBar,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            BackgroundColor(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ViewComplaintsWidget(
                      code: data["landlord_code"],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
