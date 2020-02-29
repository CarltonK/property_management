import 'dart:convert';

import 'package:property_management/models/complaintsmodel.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String firstName;
  String lastName;
  String email;
  String natId;
  String phone;
  DateTime registerDate;
  DateTime reminder;
  String apartmentName;
  String designation;
  String paybill;
  int lordCode;
  Complaints complaints;
  String password;
  String uid;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.natId,
    this.phone,
    this.registerDate,
    this.reminder,
    this.designation,
    this.paybill,
    this.lordCode,
    this.complaints,
    this.apartmentName,
    this.password,
    this.uid
});

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    natId: json["natId"],
    phone: json["phone"],
    registerDate: json["registerDate"],
    reminder: json["reminder"],
    designation: json["designation"],
    paybill: json["paybill"],
    complaints: Complaints.fromJson(json["complaints"]),
    password: json["password"],
    uid: json["uid"],
    lordCode: json["lordCode"],
    apartmentName: json["apartmentName"]
  );

  //Convert Dart object to JSON
  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "natId": natId,
    "phone": phone,
    "registerDate": registerDate,
    "reminder": reminder,
    "designation": designation,
    "paybill": paybill,
    "complaints": complaints.toJson(),
    "password": password,
    "uid": uid,
    "lordCode": lordCode,
    "apartmentName": apartmentName
  };

}
