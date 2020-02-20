import 'package:flutter/material.dart';
import 'package:property_management/auth/forgot_pass.dart';
import 'package:property_management/auth/login.dart';
import 'package:property_management/auth/registration.dart';
import 'package:property_management/pages/tenant.dart';
import 'package:property_management/pages/tenant_home.dart';
import 'package:property_management/pages/tenant_prof.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Management',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Login(),
        '/register': (context) => Registration(),
        '/tenant-home': (context) => TenantBase(),
        '/tenant-profile': (context) => TenantProfile(),
        '/reset': (context) => ForgotPassword(),
        '/login': (context) => Login(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.blue, elevation: 0),
        primarySwatch: Colors.blue,
      ),
    );
  }
}
