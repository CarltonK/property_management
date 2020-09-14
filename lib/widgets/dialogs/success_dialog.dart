import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  const SuccessDialog({Key key, @required this.message}) : assert(message != null);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        children: [
          Icon(
            Icons.done,
            color: Colors.green,
            size: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            message ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.black,
            )),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
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
        )
      ],
    );
  }
}
