import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';

class ProviderHistory extends StatelessWidget {
  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      title: Text(
        'History',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Stack(
        children: [BackgroundColor()],
      ),
    );
  }
}
