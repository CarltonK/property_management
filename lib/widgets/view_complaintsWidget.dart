import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewComplaintsWidget extends StatefulWidget {
  final int code;
  ViewComplaintsWidget({Key key, @required this.code}) : super (key: key);

  @override
  _ViewComplaintsWidgetState createState() => _ViewComplaintsWidgetState();
}

class _ViewComplaintsWidgetState extends State<ViewComplaintsWidget> {

  Future _getComplaints() async {
    //This is the name of the collection containing complaints
    final String _collection = 'complaints';
    //Create a variable to store Firestore instance
    final Firestore _fireStore = Firestore.instance;
    QuerySnapshot query = await _fireStore
        .collection(_collection)
        .where('landlord_code', isEqualTo: widget.code)
        .getDocuments();
    print('Here are the documents ${query.documents}');
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: _getComplaints(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //There is an error loading the data
            if (snapshot.hasError) {
              print('Snapshot Error: ${snapshot.error.toString()}');
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Ooops! ${snapshot.error.toString()}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent[700],
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
                    'You have not received complaints',
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
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var date = snapshot.data[index].data['date'];
                    var tenant = snapshot.data[index].data['tenant'];
                    var hse = snapshot.data[index].data['hse'];
                    var title = snapshot.data[index].data['title'];
                    bool fixed = snapshot.data[index].data['fixed'];

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.grey[100],
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Text(
                          '$hse',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 20
                              )
                          ),
                        ),
                        isThreeLine: true,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$title',
                              style: GoogleFonts.quicksand(
                                  textStyle:
                                  TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500)),
                            ),
                            Text(
                              '${DateTime.parse(date)}',
                              style: GoogleFonts.quicksand(
                                  textStyle:
                                  TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        title: Text(
                          '$tenant',
                          style: GoogleFonts.quicksand(
                              textStyle:
                              TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)),
                        ),
                        trailing: Column(
                          children: <Widget>[
                            Text(
                              'Done',
                              style: GoogleFonts.quicksand(
                                  textStyle:
                                  TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Icon(fixed ? Icons.done : Icons.cancel,
                              color: fixed ? Colors.green[900] : Colors.red,),
                          ],
                        ),
                      ),
                    );
                  },);
                break;
            }
            return Center(
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 150.0,
                ));
          }),
    );
  }
}
