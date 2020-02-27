import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

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
        .getDocuments();
    print('Here are the documents ${query.documents}');
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    tenantdata = ModalRoute.of(context).settings.arguments;
    print('Complaints Page Data: $tenantdata');

    return Scaffold(
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
                padding: EdgeInsets.only(top: 30,),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _appBarLayout(context, tenantdata),
                      Container(
                        height: MediaQuery.of(context).size.height,
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
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          color: Colors.grey[100],
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: ListTile(
                                            leading: Text(
                                              '$hse',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.green[900],
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
                                                  '${DateTime.parse(date)}',
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

Widget _appBarLayout(BuildContext context, Map<String, dynamic> data) {
  //This custom appBar replaces the Flutter App Bar
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Complaints',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
        ),
        FloatingActionButton(
          elevation: 10,
          mini: false,
          splashColor: Colors.greenAccent[700],
          tooltip: 'Add a new complaint',
          onPressed: () {
            print('I want to add a new complaint');
            Navigator.of(context).pushNamed('/add-complaint', arguments: data);
          },
          backgroundColor: Colors.green[900],
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        )
      ],
    ),
  );
}
