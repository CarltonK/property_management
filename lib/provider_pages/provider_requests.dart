import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/database_provider.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';
import 'package:property_management/widgets/utilities/loading_spinner.dart';
import 'package:provider/provider.dart';

class ProviderRequest extends StatelessWidget {
  final String uid;
  ProviderRequest({@required this.uid});

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      title: Text(
        'Requests',
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context, Future future) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Text('There is an error: ${snapshot.error.toString()}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return LoadingSpinner();
          case ConnectionState.active:
          case ConnectionState.none:
            return Text('No Data');
          case ConnectionState.done:
            return Text('There is data');
          default:
            return LoadingSpinner();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future future =
        context.read<DatabaseProvider>().receiveServiceRequests(uid);
    return Scaffold(
      appBar: appBar(),
      body: Stack(
        children: [
          BackgroundColor(),
          body(context, future),
        ],
      ),
    );
  }
}
