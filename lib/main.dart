import 'package:flutter/material.dart';
import 'package:property_management/admin_pages/add_landlord.dart';
import 'package:property_management/admin_pages/admin.dart';
import 'package:property_management/auth/forgot_pass.dart';
import 'package:property_management/auth/login.dart';
import 'package:property_management/auth/registration.dart';
import 'package:property_management/manager_pages/manager.dart';
import 'package:property_management/newbie_pages/newbie.dart';
import 'package:property_management/owner_pages/add_listing.dart';
import 'package:property_management/owner_pages/add_manager.dart';
import 'package:property_management/owner_pages/owner.dart';
import 'package:property_management/owner_pages/tenant_verify.dart';
import 'package:property_management/tenant_pages/add_complaint.dart';
import 'package:property_management/tenant_pages/tenant.dart';
import 'package:property_management/tenant_pages/tenant_prof.dart';
import 'package:property_management/welcome.dart';
import 'package:property_management/widgets/view_tenantsWidgets.dart';
import 'package:property_management/widgets/view_listingsWidget.dart';

void main() => runApp(MyApp());

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
        //Owner
        '/owner_home': (context) => OwnerBase(),
        '/add-manager': (context) => AddManager(),
        '/add-listing': (context) => AddListing(),
        '/view-tenants': (context) => ViewTenants(),
        '/view-listings': (context) => ViewListings(),
        '/tenant-verify': (context) => TenantVerify(),
        //Manager
        '/manager': (context) => Manager(),
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
