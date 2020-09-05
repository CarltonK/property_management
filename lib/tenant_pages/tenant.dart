import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/firebase_api.dart';
import 'package:property_management/tenant_pages/ten_complaint.dart';
import 'package:property_management/tenant_pages/ten_search.dart';
import 'package:property_management/tenant_pages/ten_vacate.dart';
import 'package:property_management/tenant_pages/tenant_home.dart';
import 'package:property_management/tenant_pages/tenant_services.dart';

class TenantBase extends StatefulWidget {
  @override
  _TenantBaseState createState() => _TenantBaseState();
}

class _TenantBaseState extends State<TenantBase> {
  int _selectedIndex = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetTenants = [
    TenantHome(),
    TenSearch(),
    TenVacate(),
    TenantComplain(),
    TenantSettings()
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
              ),
            ),
          ),
          content: Text(
            'Are you sure ? ',
            style: GoogleFonts.muli(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
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
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: _logOutUser,
              child: Text(
                'YES',
                style: GoogleFonts.muli(
                  textStyle: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            )
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
            textStyle: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    //print('$data');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(),
              width: MediaQuery.of(context).size.width,
              child: _widgetTenants[_selectedIndex],
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.green[900],
              items: [
                bottomBarItem(Icons.home, 'Home'),
                bottomBarItem(Icons.search, 'Search'),
                bottomBarItem(Icons.exit_to_app, 'Vacate'),
                bottomBarItem(Icons.comment, 'Complaints'),
                bottomBarItem(Icons.accessibility, 'Services')
              ],
              currentIndex: _selectedIndex,
              onTap: _onIndexChanged,
            ),
          )),
    );
  }
}
