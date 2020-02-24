import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.white
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[900],
          borderRadius: BorderRadius.circular(10),
        ),
        height: 140,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.only(left: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80',
                      fit: BoxFit.fill,),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            'Ngara',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white
                              )
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.favorite, color: Colors.red,),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        '2 Bedrooms',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white
                            )
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'KES 15000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.white
                            )
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
