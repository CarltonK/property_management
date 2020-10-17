import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({Key key, @required this.message})
      : assert(message != null);
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        message,
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
