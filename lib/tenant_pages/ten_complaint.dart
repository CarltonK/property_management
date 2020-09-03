import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TenantComplain extends StatelessWidget {
  static Map<String, dynamic> tenantdata;

  Future _getComplaints() async {
    //This is the name of the collection containing complaints
    final String _collection = 'complaints';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .where("landlord_code", isEqualTo: tenantdata["landlord_code"])
        .where("uid", isEqualTo: tenantdata["uid"])
        .orderBy("date", descending: true)
        .getDocuments();
    //print('Here are the documents ${query.documents}');
    return query.documents;
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      title: Text(
        'Kejani',
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget showError(String message) {
    return Center(
      child: Text(
        message,
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

  @override
  Widget build(BuildContext context) {
    tenantdata = ModalRoute.of(context).settings.arguments;
    //print('Complaints Page Data: $tenantdata');
    return Scaffold(
      appBar: appBar(context),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[900],
                ),
              ),
              Container(
                //This Container lays out the UI
                padding: EdgeInsets.only(
                  top: 10,
                ),
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("complaints")
                              .where("landlord_code",
                                  isEqualTo: tenantdata["landlord_code"])
                              .where("uid", isEqualTo: tenantdata["uid"])
                              .orderBy("date", descending: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            //There is an error loading the data
                            if (snapshot.hasError) {
                              print(
                                'Snapshot Error: ${snapshot.error.toString()}',
                              );
                              return showError(
                                'Ooops! You need a code from your landlord to view and post complaints',
                              );
                            }
                            if (snapshot.data == null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'You have not posted any complaints',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 150.0,
                                  )
                                ],
                              );
                            }
                            if (snapshot.data.documents.length == 0) {
                              return showError(
                                'You have not posted any complaints',
                              );
                            }
                            if (snapshot.hasData) {
                              return Container(
                                height: double.infinity,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                    color: Colors.white,
                                  ),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    var date = snapshot
                                        .data.documents[index].data['date'];
                                    var tenant = snapshot
                                        .data.documents[index].data['tenant'];
                                    var hse = snapshot
                                        .data.documents[index].data['hse'];
                                    var title = snapshot
                                        .data.documents[index].data['title'];
                                    bool fixed = snapshot
                                        .data.documents[index].data['fixed'];
                                    var reply = snapshot
                                        .data.documents[index].data['message'];

                                    //Date Parsing and Formatting
                                    var parsedDate = DateTime.parse(date);
                                    var formatter = new DateFormat('yMMMd');
                                    String dateFormatted =
                                        formatter.format(parsedDate);

                                    return ComplaintCard(
                                      hse: hse,
                                      title: title,
                                      dateFormatted: dateFormatted,
                                      reply: reply,
                                      tenant: tenant,
                                      fixed: fixed,
                                    );
                                  },
                                ),
                              );
                            }
                            return Center(
                              child: SpinKitFadingCircle(
                                color: Colors.white,
                                size: 150.0,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        padding: EdgeInsets.all(6),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        splashColor: Colors.greenAccent[700],
        onPressed: () {
          print('I want to add a new complaint');
          Navigator.of(context).pushNamed(
            '/add-complaint',
            arguments: tenantdata,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.mode_edit,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Complaint',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({
    Key key,
    @required this.hse,
    @required this.title,
    @required this.dateFormatted,
    @required this.reply,
    @required this.tenant,
    @required this.fixed,
  }) : super(key: key);

  final dynamic hse;
  final dynamic title;
  final String dateFormatted;
  final dynamic reply;
  final dynamic tenant;
  final bool fixed;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$hse',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$dateFormatted',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            reply == null
                ? SizedBox(
                    height: 1,
                  )
                : Text(
                    'Manager: $reply',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
        title: Text(
          '$tenant',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Status',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Icon(
              fixed ? Icons.done : Icons.cancel,
              color: fixed ? Colors.green[900] : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
