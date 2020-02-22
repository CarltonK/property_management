import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/widgets/searchresults.dart';

class TenSearch extends StatefulWidget {
  @override
  _TenSearchState createState() => _TenSearchState();
}

class _TenSearchState extends State<TenSearch> {
  Widget _singleChildComplaint2() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        subtitle: Text(
          '31 Jan 2020',
          style: GoogleFonts.quicksand(
              textStyle:
                  TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500)),
        ),
        title: Text(
          'Faulty tap',
          style: GoogleFonts.quicksand(
              textStyle:
                  TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.done_all,
              color: Colors.green,
            ),
            onPressed: null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                    color: Colors.indigo[900]
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _appBarLayout(),
                      SizedBox(
                        height: 10,
                      ),
                      _filterChips(),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: ListView(
                          itemExtent: 140,
                          children: <Widget>[
                            SearchResults(),
                            SearchResults(),
                            SearchResults(),
                            SearchResults(),
                            SearchResults(),
                            SearchResults(),
                            SearchResults(),
                            SearchResults(),
                            SearchResults(),
                            SearchResults()
                          ],
                        ),
                      ),
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

Widget _filterChips() {
  return Container(
    height: 50,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Chip(
          label: Text(
            'Rent',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ),
          padding: EdgeInsets.all(10),
          backgroundColor: Colors.white,
          elevation: 10,
        ),
        SizedBox(
          width: 10,
        ),
        Chip(
          label: Text(
            '2 Bedrooms',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ),
          padding: EdgeInsets.all(10),
          backgroundColor: Colors.white,
          elevation: 10,
        ),
        SizedBox(
          width: 10,
        ),
        Chip(
          label: Text(
            '< 15000',
            style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ),
          padding: EdgeInsets.all(10),
          backgroundColor: Colors.white,
          elevation: 10,
        )
      ],
    ),
  );
}

Widget _appBarLayout() {
  //This custom appBar replaces the Flutter App Bar
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Search',
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
          splashColor: Colors.indigo,
          tooltip: 'Adjust filters',
          onPressed: () {
            print('I want to adjust filters');
          },
          backgroundColor: Colors.indigo[900],
          child: Icon(
            Icons.list,
            color: Colors.white,
            size: 30,
          ),
        )
      ],
    ),
  );
}
