import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesList extends StatefulWidget {
  final String type;
  ServicesList({@required this.type});

  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  Widget appBar() {
    final String type = widget.type.replaceFirst(
      widget.type[0],
      widget.type[0].toUpperCase(),
    );
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30,
        ),
      ),
      title: Text(
        type ?? '',
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
    );
  }
}
