import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TenantComplain extends StatelessWidget {
  Map<String, dynamic> tenantdata;

  Future _getComplaints() async {
    //This is the name of the collection containing complaints
    final String _collection = 'users';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .document(tenantdata["uid"])
        .collection("complaints_history")
        .orderBy("date",descending: true)
        .getDocuments();
    print('Here are the documents ${query.documents}');
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    tenantdata = ModalRoute.of(context).settings.arguments;
    print('Complaints Page Data: $tenantdata');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          'Kejani',
          style: GoogleFonts.quicksand(
              textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                print('I want to add a new complaint');
                Navigator.of(context)
                    .pushNamed('/add-complaint', arguments: tenantdata);
              })
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.green[900]),
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
                        child: FutureBuilder(
                            future: _getComplaints(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              //There is an error loading the data
                              if (snapshot.hasError) {
                                print(
                                    'Snapshot Error: ${snapshot.error.toString()}');
                                return Center(
                                    child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Text(
                                      'Ooops! You need a code from your landlord to view and post complaints',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      )),
                                    )
                                  ],
                                ));
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 150.0,
                                  ));
                                  break;
                                case ConnectionState.none:
                                  return Text('none');
                                  break;
                                case ConnectionState.active:
                                  return Text('none');
                                  break;
                                case ConnectionState.done:
                                  if (snapshot.data.length == 0) {
                                    return Text(
                                      'You have not posted any complaints',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 25,
                                      )),
                                    );
                                  }
                                  //print('${snapshot.data[0].data["landlord_code"]}');
                                  return Container(
                                    height: double.infinity,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        color: Colors.white,
                                      ),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        var date =
                                            snapshot.data[index].data['date'];
                                        var tenant =
                                            snapshot.data[index].data['tenant'];
                                        var hse =
                                            snapshot.data[index].data['hse'];
                                        var title =
                                            snapshot.data[index].data['title'];
                                        bool fixed =
                                            snapshot.data[index].data['fixed'];

                                        //Date Parsing and Formatting
                                        var parsedDate = DateTime.parse(date);
                                        var formatter = new DateFormat('yMMMd');
                                        String dateFormatted = formatter.format(parsedDate);
                                        
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          color: Colors.grey[100],
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: ListTile(
                                            leading: Text(
                                              '$hse',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.green[900],
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20)),
                                            ),
                                            isThreeLine: true,
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '$title',
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Colors.green[900],
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                                Text(
                                                  '$dateFormatted',
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Colors.green[900],
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ],
                                            ),
                                            title: Text(
                                              '$tenant',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.green[900],
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            trailing: Column(
                                              children: <Widget>[
                                                Text(
                                                  'Done',
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Colors.green[900],
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Icon(
                                                  fixed
                                                      ? Icons.done
                                                      : Icons.cancel,
                                                  color: fixed
                                                      ? Colors.green[900]
                                                      : Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                  break;
                              }
                              return Center(
                                  child: SpinKitFadingCircle(
                                color: Colors.white,
                                size: 150.0,
                              ));
                            }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
