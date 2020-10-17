import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogOutDialog extends StatelessWidget {
  final Function yesClick;
  const LogOutDialog({Key key, @required this.yesClick})
      : assert(yesClick != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'EXIT',
        style: GoogleFonts.muli(
          textStyle: TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      content: Text(
        'Are you sure ? ',
        style: GoogleFonts.muli(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'NO',
            style: GoogleFonts.muli(
              textStyle: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        FlatButton(
          onPressed: yesClick,
          child: Text(
            'YES',
            style: GoogleFonts.muli(
              textStyle: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }
}
