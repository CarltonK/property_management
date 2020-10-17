import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({Key key, @required this.title}) : assert(title != null);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.quicksand(
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          letterSpacing: .2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
