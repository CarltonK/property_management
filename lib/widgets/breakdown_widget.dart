import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/floortile.dart';

class Breakdown extends StatefulWidget {
  final List<DocumentSnapshot> snapshot;
  final int code;
  Breakdown({Key key, @required this.snapshot, @required this.code})
      : super(key: key);

  @override
  _BreakdownState createState() => _BreakdownState();
}

class _BreakdownState extends State<Breakdown> {
  @override
  Widget build(BuildContext context) {
    //print('Data: ${widget.snapshot[0].data}');
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: widget.snapshot
            .map(
              (map) => ExpansionTile(
                title: Text(
                  'Floor: ${map["floorNumber"]}',
                  style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600)),
                ),
                children: <Widget>[
                  FloorTile(
                    code: widget.code,
                    floor: map["floorNumber"],
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
