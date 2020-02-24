import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Breakdown extends StatefulWidget {
  @override
  _BreakdownState createState() => _BreakdownState();
}

class _BreakdownState extends State<Breakdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Floor: 1',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  )
              ),
            ),
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text(
                    'Wayne Rooney',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  leading: Text(
                    '101',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '1 Jan',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      ),
                      Text(
                        '12,000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.done, color: Colors.blue,),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Colors.greenAccent[700]
                    )
                ),
                color: Colors.green[900],

              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Lionel Messi',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  leading: Text(
                    '102',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '3 Jan',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      ),
                      Text(
                        '12,000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.done, color: Colors.blue,),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Colors.greenAccent[700]
                    )
                ),
                color: Colors.green[900],

              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Neymar',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  leading: Text(
                    '103',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '3 days late',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      ),
                      Text(
                        '12,000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.cancel, color: Colors.red,),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Colors.greenAccent[700]
                    )
                ),
                color: Colors.green[900],

              )
            ],
          ),
          ExpansionTile(
            title: Text(
              'Floor: 2',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  )
              ),
            ),
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text(
                    'Lionel Messi',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  leading: Text(
                    '102',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '3 Jan',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      ),
                      Text(
                        '12,000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.done, color: Colors.blue,),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Colors.greenAccent[700]
                    )
                ),
                color: Colors.green[900],

              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Neymar',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  leading: Text(
                    '103',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '3 days late',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      ),
                      Text(
                        '12,000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.cancel, color: Colors.red,),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Colors.greenAccent[700]
                    )
                ),
                color: Colors.green[900],

              )
            ],),
          ExpansionTile(
            title: Text(
              'Floor: 3',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  )
              ),
            ),
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text(
                    'Lionel Messi',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  leading: Text(
                    '102',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '3 Jan',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      ),
                      Text(
                        '12,000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.done, color: Colors.blue,),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Colors.greenAccent[700]
                    )
                ),
                color: Colors.green[900],

              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Neymar',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  leading: Text(
                    '103',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '3 days late',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      ),
                      Text(
                        '12,000',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.cancel, color: Colors.red,),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Colors.greenAccent[700]
                    )
                ),
                color: Colors.green[900],

              )
            ],),
          ExpansionTile(
            title: Text(
              'Floor: 4',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  )
              ),
            ),),
          ExpansionTile(
            title: Text(
              'Floor: 5',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  )
              ),
            ),)
        ],
      ),
    );
  }
}
