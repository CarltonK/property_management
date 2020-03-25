import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/owner_pages/owner_complaint.dart';
import 'package:property_management/owner_pages/owner_home.dart';
import 'package:property_management/owner_pages/owner_settings.dart';
import 'package:property_management/owner_pages/owner_vacations.dart';

class OwnerBase extends StatefulWidget {
  @override
  _OwnerBaseState createState() => _OwnerBaseState();
}

class _OwnerBaseState extends State<OwnerBase> {
  int _selectedIndex = 0;
  static Map<String, dynamic> data;
  static String uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _ownerTenants = [
    OwnerHome(),
    OwnerComplaint(),
    OwnerVacations(),
    OwnerSettings()
  ];

  Future _buildLogOutSheet(BuildContext context) {
    return showCupertinoModalPopup(
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            'EXIT',
            style: GoogleFonts.muli(
                textStyle: TextStyle(
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            )),
          ),
          content: Text(
            'Are you sure ? ',
            style: GoogleFonts.muli(
                textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'NO',
                  style: GoogleFonts.muli(
                      textStyle: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
                )),
            FlatButton(
                onPressed: _logOutUser,
                child: Text(
                  'YES',
                  style: GoogleFonts.muli(
                      textStyle: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
                ))
          ],
        );
      },
      context: context,
    );
  }

  API _api = API();

  void _logOutUser() async {
    dynamic result = await _api.logout();
    print(result);
    //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<bool> _onWillPop() {
    return _buildLogOutSheet(context) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    //print('Data pulled: $data');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.green[900]),
                ),
                Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  child: _ownerTenants[_selectedIndex],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.green[900],
              selectedFontSize: 16,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.green[900],
                      size: 30,
                    ),
                    title: Text(
                      'Home',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(fontWeight: FontWeight.w500)),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.comment,
                      color: Colors.green[900],
                      size: 30,
                    ),
                    title: Text('Complaints',
                        style: GoogleFonts.quicksand(
                            textStyle:
                                TextStyle(fontWeight: FontWeight.w500)))),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.green[900],
                      size: 30,
                    ),
                    title: Text('Vacate',
                        style: GoogleFonts.quicksand(
                            textStyle:
                                TextStyle(fontWeight: FontWeight.w500)))),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.green[900],
                      size: 30,
                    ),
                    title: Text('Settings',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(fontWeight: FontWeight.w500))))
              ],
              currentIndex: _selectedIndex,
              onTap: _onIndexChanged,
            ),
          )),
    );
  }
}
