import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:property_management/admin_pages/add_landlord.dart';
import 'package:property_management/admin_pages/admin.dart';
import 'package:property_management/auth/forgot_pass.dart';
import 'package:property_management/auth/login.dart';
import 'package:property_management/auth/registration.dart';
import 'package:property_management/manager_pages/manager.dart';
import 'package:property_management/manager_pages/manager_prof.dart';
import 'package:property_management/manager_pages/record_cash.dart';
import 'package:property_management/newbie_pages/newbie.dart';
import 'package:property_management/owner_pages/add_listing.dart';
import 'package:property_management/owner_pages/add_manager.dart';
import 'package:property_management/owner_pages/owner.dart';
import 'package:property_management/owner_pages/tenant_verify.dart';
import 'package:property_management/tenant_pages/add_complaint.dart';
import 'package:property_management/tenant_pages/announcement.dart';
import 'package:property_management/tenant_pages/tenant.dart';
import 'package:property_management/tenant_pages/tenant_prof.dart';
import 'package:property_management/welcome.dart';
import 'package:property_management/widgets/view_listingsWidget.dart';
import 'package:property_management/widgets/view_tenantsWidgets.dart';

void main() {
  //Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kejani',
      debugShowCheckedModeBanner: false,
      routes: {
        //Default route
        '/': (context) => Welcome(),
        //Authentication
        '/register': (context) => Registration(),
        '/reset': (context) => ForgotPassword(),
        '/login': (context) => Login(),
        //Tenant
        '/tenant-home': (context) => TenantBase(),
        '/tenant-profile': (context) => TenantProfile(),
        '/add-complaint': (context) => AddComplaint(),
        '/announcement': (context) => Announcement(),
        //Owner
        '/owner_home': (context) => OwnerBase(),
        '/add-manager': (context) => AddManager(),
        '/add-listing': (context) => AddListing(),
        '/view-tenants': (context) => ViewTenants(),
        '/view-listings': (context) => ViewListings(),
        '/tenant-verify': (context) => TenantVerify(),
        //Manager
        '/manager': (context) => Manager(),
        '/manager-prof': (context) => ManagerProf(),
        '/record-cash': (context) => RecordCash(),
        //Newbie
        '/newbie': (context) => Newbie(),
        //Admin
        '/admin': (context) => Admin(),
        '/add': (context) => AddLandlord(),
      },
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blue, elevation: 0),
          primarySwatch: Colors.blue,
          dividerColor: Colors.white,
          unselectedWidgetColor: Colors.white),
    );
  }
}
