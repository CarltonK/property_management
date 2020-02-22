import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_management/pages/ten_complaint.dart';
import 'package:property_management/pages/ten_search.dart';
import 'package:property_management/pages/ten_vacate.dart';
import 'package:property_management/pages/tenant_home.dart';

class TenantBase extends StatefulWidget {
  @override
  _TenantBaseState createState() => _TenantBaseState();
}

class _TenantBaseState extends State<TenantBase> {
  int _selectedIndex = 0;

  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.indigo[900]
                ),
              ),
              Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  children: <Widget>[
                    TenantHome(),
                    TenSearch(),
                    TenVacate(),
                    TenantComplain(),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.indigo[900],
            height: 50,
            index: _selectedIndex,
            items: [
              Icon(
                Icons.home,
                color: Colors.indigo[900],
                size: 30,
              ),
              Icon(
                Icons.search,
                color: Colors.indigo[900],
                size: 30,
              ),
              Icon(
                Icons.exit_to_app,
                color: Colors.indigo[900],
                size: 30,
              ),
              Icon(
                Icons.comment,
                color: Colors.indigo[900],
                size: 30,
              )
            ],
            onTap: (index) => setState(() {
                  _selectedIndex = index;
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 10),
                      curve: Curves.easeInOut);
                })));
  }
}
