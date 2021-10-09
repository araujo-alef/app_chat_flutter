import 'package:chat_app/chatScreen.dart';
import 'package:chat_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Service{
  // in service class we done all firebase auth
  final auth = FirebaseAuth.instance;
  // for create user we define function

  void createUser(context, email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()))
      });
    } catch (e) {
      errorBox(context, e);
    }
  }

  // for login user we define loginUser function
  void loginUser(context, email, password) async {
    try {
      
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value) => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()))
      });

    } catch (e) {
      errorBox(context, e);
    }
  }

  //for signout
  void signOut(context) async {
    try {
      await auth.signOut().then((value) => {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false)
      });
    } catch (e) {
      errorBox(context, e);
    }
  }

  // for displaying error we define errorBox function

  void errorBox(context, e) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(e.toString()),
      );
    });
  }
}