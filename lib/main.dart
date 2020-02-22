import 'package:flutter/material.dart';
import 'package:property_management/auth/forgot_pass.dart';
import 'package:property_management/auth/login.dart';
import 'package:property_management/auth/registration.dart';
import 'package:property_management/owner_pages/owner.dart';
import 'package:property_management/tenant_pages/tenant.dart';
import 'package:property_management/tenant_pages/tenant_prof.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Management',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => OwnerBase(),
        //Authentication
        '/register': (context) => Registration(),
        '/reset': (context) => ForgotPassword(),
        '/login': (context) => Login(),
        //Tenant
        '/tenant-home': (context) => TenantBase(),
        '/tenant-profile': (context) => TenantProfile(),
        //Owner
        '/owner_home': (context) => OwnerBase()
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.blue, elevation: 0),
        primarySwatch: Colors.blue,
      ),
    );
  }
}
