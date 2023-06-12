import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myClinic/Homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: Homepage(),
    debugShowCheckedModeBanner: false,
  ));
}
