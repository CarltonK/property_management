import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminStats extends StatefulWidget {
  @override
  _AdminStatsState createState() => _AdminStatsState();
}

class _AdminStatsState extends State<AdminStats> {
  Widget singleCard(String service, Map data) {
    final String title = service.replaceFirst(
      service[0],
      service[0].toUpperCase(),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.accessibility,
              size: 35,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title ?? '',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              data[service].toString() ?? '',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> categories = [
    'amount',
    'complaints',
    'landlords',
    'listings',
    'payments',
    'tenants',
    'vacations'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection("analytics")
            .document('Qcm7O4YJlhJe4TIFbw8n')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) =>
                  singleCard(categories[index], snapshot.data.data),
              itemCount: categories.length,
            );
          return Center(
            child: SpinKitCircle(
              size: 150,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
