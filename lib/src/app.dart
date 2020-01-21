import 'package:flutter/material.dart';
import 'package:sidedrawer/screens/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homescreen(),
      theme: ThemeData(
       primaryColor: Colors.red,
       accentColor: Colors.redAccent,
       
      ),
    );
  }
}
