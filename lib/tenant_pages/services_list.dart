import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_management/api/database_provider.dart';
import 'package:property_management/widgets/dialogs/error_dialog.dart';
import 'package:property_management/widgets/dialogs/leave_page_dialog.dart';
import 'package:property_management/widgets/dialogs/success_dialog.dart';
import 'package:property_management/widgets/utilities/loading_spinner.dart';
import 'package:property_management/widgets/utilities/styles.dart';

class ServicesList extends StatefulWidget {
  final String type;
  final String desc;
  final Map<String, dynamic> user;
  ServicesList({@required this.type, @required this.desc, @required this.user});

  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  Future future;
  DatabaseProvider _provider = DatabaseProvider();
  Widget appBar() {
    final String type = widget.type.replaceFirst(
      widget.type[0],
      widget.type[0].toUpperCase(),
    );
    return AppBar(
      backgroundColor: Colors.green[900],
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30,
        ),
      ),
      title: Text(
        type ?? '',
        style: titleStyle,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    future = _provider.fetchConcernedServiceProvider(widget.type);
  }

  Widget showError(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget backgroundColor() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[900],
            Colors.green[800],
            Colors.green[700],
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ),
      ),
    );
  }

  void tileTap(String to, String toToken) async {
    String by = widget.user['uid'];
    String byToken = widget.user['token'];
    String byName = widget.user['fullName'];

    _provider
        .sendServiceRequest(by, byToken, to, toToken, byName, widget.desc)
        .whenComplete(() {
      showCupertinoModalPopup(
        context: context,
        builder: (context) =>
            SuccessDialog(message: 'Your request has been placed.'),
      );
    }).catchError((error) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => ErrorDialog(message: error.toString()),
      );
    });
  }

  String formattedDate(Timestamp date) {
    DateTime now = DateTime.now();
    Timestamp dateRegistered = date;
    DateTime retrieved = dateRegistered.toDate();

    int timeDiff = now.difference(retrieved).inDays;
    String elapsed;

    if (timeDiff < 1) {
      int hours = now.difference(retrieved).inHours;
      if (hours < 1) {
        int minutes = now.difference(retrieved).inMinutes;
        elapsed = '$minutes minutes ago';
      } else if (hours == 1) {
        elapsed = '$hours hour ago';
      } else {
        elapsed = '$hours hours ago';
      }
    } else {
      if (timeDiff == 1) {
        elapsed = '$timeDiff day ago';
      } else {
        elapsed = '$timeDiff days ago';
      }
    }
    return elapsed;
  }

  Widget singleProviderView(DocumentSnapshot prov) {
    String name = prov.data['fullName'];
    String rate = prov.data['rating'].toString();
    String to = prov.documentID;
    String toToken = prov.data['token'];

    String elapsedDate = formattedDate(prov.data['registerDate']);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => tileTap(to, toToken),
        title: Text(
          name,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        leading: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
        subtitle: Text(
          'Member since $elapsedDate',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rating',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              rate != null ? rate : '0',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return _buildLeavePageSheet(context) ?? false;
  }

  Future _buildLeavePageSheet(BuildContext context) {
    return showCupertinoModalPopup(
      builder: (context) {
        return LeavePageDialog();
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: appBar(),
        body: Stack(
          children: [
            backgroundColor(),
            Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: _provider.getUser(widget.user['uid']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data.data['isPremium'] == true) {
                      return FutureBuilder<List<DocumentSnapshot>>(
                        future: future,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return LoadingSpinner();
                            case ConnectionState.none:
                              return showError(
                                  'There are no service providers available');
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.data.length == 0)
                                return showError(
                                  'There are no service providers available',
                                );
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 5.0,
                                ),
                                child: ListView.builder(
                                  itemBuilder: (context, index) =>
                                      singleProviderView(
                                    snapshot.data[index],
                                  ),
                                  itemCount: snapshot.data.length,
                                ),
                              );
                            default:
                              return LoadingSpinner();
                          }
                        },
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingSpinner(),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Please wait while we process your request',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
