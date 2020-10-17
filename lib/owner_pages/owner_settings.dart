import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';

class OwnerSettings extends StatefulWidget {
  @override
  _OwnerSettingsState createState() => _OwnerSettingsState();
}

class _OwnerSettingsState extends State<OwnerSettings> {
  int code;
  static Map<String, dynamic> data;
  String apartmentName;
  String tenName;

  Widget addManager() {
    return MaterialButton(
      color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      splashColor: Colors.greenAccent[700],
      onPressed: () {
        Navigator.of(context).pushNamed(
          '/add-manager',
          arguments: data,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.person_add,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Add a manager',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _deleteManager(String docID) async {
    // print('The docId is $docID');
    //Delete the document in "managers"
    await Firestore.instance.collection("managers").document(docID).delete();
    //Delete the document in "users"
    await Firestore.instance.collection("users").document(docID).delete();
  }

  Widget listingsWidget() {
    return Expanded(
      flex: 2,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print('I want to view listings');
                  Navigator.of(context).pushNamed(
                    '/view-listings',
                    arguments: data,
                  );
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.location_city,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Listings',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget singleManager(DocumentSnapshot map) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[100],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[100],
        ),
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            dense: true,
            leading: Icon(Icons.person_outline),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Delete',
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    _deleteManager(map.documentID);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            title: Text(
              '${map["fullName"]}',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Text(
              '${map["apartment_name"]}',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget errorMessage(String message) {
    return Expanded(
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget managersBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("managers")
          .where(
            "apartment_name",
            isEqualTo: apartmentName,
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Snapshot Error: ${snapshot.error.toString()}');
          return errorMessage('${snapshot.error.toString()}');
        }
        if (snapshot.data == null) {
          return errorMessage('You have no managers');
        }
        if (snapshot.data.documents.length == 0) {
          return errorMessage('You have no managers');
        }
        if (snapshot.hasData) {
          return Expanded(
            child: Container(
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: snapshot.data.documents.map(
                  (map) {
                    return singleManager(map);
                  },
                ).toList(),
              ),
            ),
          );
        }
        return Center(
          child: LinearProgressIndicator(
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget viewManagers() {
    return Expanded(
      flex: 3,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Manager(s)',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            managersBody(),
          ],
        ),
      ),
    );
  }

  Widget globalOwnerBar(var data) {
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(
            '/owner_prof',
            arguments: data,
          );
        },
        icon: Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 30,
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    //print('Settings Page Data: ${OwnerSettings.data}');
    code = data["landlord_code"];
    apartmentName = data["apartment_name"];

    return Scaffold(
      appBar: globalOwnerBar(data),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            BackgroundColor(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  listingsWidget(),
                  Divider(
                    thickness: 1,
                  ),
                  viewManagers(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: addManager(),
    );
  }
}
