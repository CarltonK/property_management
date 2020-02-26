import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:property_management/models/usermodel.dart';

//Use ChangeNotifier to allow widgets using this service to be updated
class API with ChangeNotifier{
  //Store a user as a variable
  var currentUser;

  API() {
    print('A new instance of API class has been created');
  }

  //create instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Return a user
  Future getUser() {
    return Future.value(currentUser);

  }

  //User Logout
  Future logout() {
    this.currentUser = null;
    notifyListeners();
    return Future.value(currentUser);
  }

  //Sign In
  Future signInEmailPass(User user) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password);
      currentUser = result.user;
      print('Positive Response: ${currentUser}');
      notifyListeners();
      return Future.value(currentUser);
    }
    catch (e) {
      var response;
      if (e.toString().contains("ERROR_WRONG_PASSWORD")) {
        response = 'Invalid credentials. Please try again';
        print('Negative Response: $response');
      }
      if (e.toString().contains("ERROR_INVALID_EMAIL")) {
        response = 'Invalid Email. Please enter the correct email';
        print('Negative Response: $response');
      }
      if (e.toString().contains("ERROR_USER_NOT_FOUND")) {
        response = 'Please register first';
        print('Negative Response: $response');
      }
      if (e.toString().contains("ERROR_USER_DISABLED")) {
        response = 'Your account has been disabled';
        print('Negative Response: $response');
      }
      if (e.toString().contains("ERROR_TOO_MANY_REQUESTS")) {
        response = 'Too many requests. Try again in 2 minutes';
        print('Negative Response: $response');
      }
      return response;
    }
  }

  //Create User
  Future createUserEmailPass(User user) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password);
      currentUser = result.user;
      //The User has registered successfully
      print('Positive Registration Response: ${currentUser.uid}');
      //Try adding the user to the Firestore
      saveUser(user,result.user.uid);
      //The user has saved successfully
      print('Positive Save Response: ${currentUser.toString()}');
      return currentUser;
    }
    catch (e) {
      var response;
      if (e.toString().contains("ERROR_WEAK_PASSWORD")) {
        response = 'Your password is weak. Please choose another';
        print('Negative Response: $response');
      }
      if (e.toString().contains("ERROR_INVALID_EMAIL")) {
        response = 'Invalid Email. Please enter the correct email';
        print('Negative Response: $response');
      }
      if (e.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {
        response = 'An account with the same email exists';
        print('Negative Response: $response');
      }
      return response;
    }
  }

  //Password reset
  Future resetPass(String email) async {
    var response;
    try {
      await _auth.sendPasswordResetEmail(
          email: email);
      response = true;
      return response;
    }
    catch (e) {
      if (e.toString().contains("ERROR_INVALID_EMAIL")) {
        response = 'Invalid Email. Please enter the correct email';
        print('Negative Response: $response');
      }
      if (e.toString().contains("ERROR_USER_NOT_FOUND")) {
        response = 'Please register first';
        print('Negative Response: $response');
      }
      return response;
    }
  }

  //Save the User as a document in the "users" collection
  void saveUser(User user, String uid) {
    //Retrieve fields
    String email = user.email;
    String firstName =  user.firstName;
    String lastName =  user.lastName;
    String phone = user.phone;
    String natId = user.natId;
    String designation = user.designation;
    DateTime registerDate = user.registerDate;
    int landlordCode = user.lordCode;
    
    if (designation == "Tenant") {
      Firestore.instance
          .collection("tenants")
          .document(uid)
          .setData({
        "email":email,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "natId": natId,
        "designation": designation,
        "registerDate": registerDate,
        "landlord_code": landlordCode
      });
    }
    else {
      Firestore.instance
          .collection("landlords")
          .document(uid)
          .setData({
        "email":email,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "natId": natId,
        "designation": designation,
        "registerDate": registerDate,
        "landlord_code": landlordCode
      });
    }

    try {
      Firestore.instance
          .collection("users")
          .document(uid).setData(
        {
          "email":email,
          "firstName": firstName,
          "lastName": lastName,
          "phone": phone,
          "natId": natId,
          "designation": designation,
          "registerDate": registerDate,
          "landlord_code": landlordCode,
        }
      );
      print("The user was successfully saved");
    }
    catch (e) {
      print("The user was not successfully saved");
      print("This is the error ${e.toString()}");
    }
  }
}
