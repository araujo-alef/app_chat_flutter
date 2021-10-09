import 'package:chat_app/chatScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

main() async {
  // check if the user emais is present in preference
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString("email");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? LoginPage() : ChatScreen(),
  ));
}