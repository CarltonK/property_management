import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OwnerComplaint extends StatefulWidget {
  @override
  _OwnerComplaintState createState() => _OwnerComplaintState();
}

class _OwnerComplaintState extends State<OwnerComplaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.indigo[900]
              ),
            )
          ],
        ),
      ),
    );
  }
}
