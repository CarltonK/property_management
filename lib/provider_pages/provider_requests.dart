import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/database_provider.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';
import 'package:property_management/widgets/utilities/loading_spinner.dart';
import 'package:property_management/widgets/utilities/no_data.dart';
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
            return NoData(message: 'You have not received any requests');
          case ConnectionState.done:
            if (snapshot.data.length == 0)
              return NoData(message: 'You have not received any requests');
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 5.0,
              ),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => singleRequestView(
                  snapshot.data[index],
                ),
              ),
            );
          default:
            return LoadingSpinner();
        }
      },
    );
  }

  Widget singleRequestView(DocumentSnapshot prov) {
    String name = prov.data['byName'];
    String status = prov.data['status'];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () {},
        title: Text(
          name,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        leading: Icon(
          Icons.person,
          color: Colors.white,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Status',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              status,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future future =
        context.watch<DatabaseProvider>().receiveServiceRequests(uid);
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
