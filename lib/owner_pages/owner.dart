import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/owner_pages/owner_complaint.dart';
import 'package:property_management/owner_pages/owner_home.dart';

class OwnerBase extends StatefulWidget {
  @override
  _OwnerBaseState createState() => _OwnerBaseState();
}

class _OwnerBaseState extends State<OwnerBase> {

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
  ];

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
                    color: Colors.green[900]
                ),
              ),
              Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                child: _ownerTenants[_selectedIndex],
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green[900],
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
                            fontWeight: FontWeight.w500
                        )
                    ),)),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.comment,
                    color: Colors.green[900],
                    size: 30,
                  ),
                  title: Text('Complaints',style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500
                      )
                  )))
            ],
            currentIndex: _selectedIndex,
            onTap: _onIndexChanged,),
        ));
  }
}
