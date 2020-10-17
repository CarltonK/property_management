import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/owner_pages/owner_complaint.dart';
import 'package:property_management/owner_pages/owner_home.dart';
import 'package:property_management/owner_pages/owner_settings.dart';
import 'package:property_management/owner_pages/owner_vacations.dart';
import 'package:property_management/widgets/dialogs/logout_dialog.dart';
import 'package:property_management/widgets/utilities/backgroundColor.dart';

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
        return LogOutDialog(yesClick: _logOutUser);
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

  bottomBarItem(IconData icon, String title) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: Colors.green[900],
        size: 30,
      ),
      title: Text(
        title,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
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
              BackgroundColor(),
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
              bottomBarItem(Icons.home, 'Home'),
              bottomBarItem(Icons.comment, 'Complaints'),
              bottomBarItem(Icons.exit_to_app, 'Vacate'),
              bottomBarItem(Icons.settings, 'Settings'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onIndexChanged,
          ),
        ),
      ),
    );
  }
}
