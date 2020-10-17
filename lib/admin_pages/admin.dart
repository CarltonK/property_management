import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/admin_pages/admin_home.dart';
import 'package:property_management/admin_pages/admin_stats.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/widgets/dialogs/logout_dialog.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  //Page Identifier
  int _selectedIndex = 0;
  //Data retriever
  static Map<String, dynamic> data;
  //uid Identifiers
  static String uid;
  //List of Pages
  List<Widget> _adminPages = [AdminHome(), AdminStats()];
  //Bottom bar page selector
  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _buildLogOutSheet(BuildContext context) {
    return showCupertinoModalPopup(
      builder: (context) {
        return LogOutDialog(yesClick: _logOutUser);
      },
      context: context,
    );
  }

  API _api = API();

  void _logOutUser() async {
    dynamic result = await _api.logout();
    print(result);
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Future<bool> _onWillPop() {
    return _buildLogOutSheet(context) ?? false;
  }

  @override
  Widget build(BuildContext context) {
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
                color: Colors.green[900],
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                child: _adminPages[_selectedIndex],
              )
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
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.subject,
                  color: Colors.green[900],
                  size: 30,
                ),
                title: Text(
                  'Stats',
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onIndexChanged,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/add'),
          backgroundColor: Colors.greenAccent[700],
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
