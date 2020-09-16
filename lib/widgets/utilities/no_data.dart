import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoData extends StatelessWidget {
  final String message;
  NoData({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? 'There is no data',
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
