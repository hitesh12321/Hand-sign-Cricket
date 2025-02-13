import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:flutter/material.dart';

import 'screens/menu_screen.dart'; // Import your menu screen

void main() async {
  // Ensure Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(const HandCricketApp());
}

class HandCricketApp extends StatelessWidget {
  const HandCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hand Cricket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(), // Start with the Menu Screen
    );
  }
}
