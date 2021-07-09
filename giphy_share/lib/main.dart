import 'package:flutter/material.dart';
import './pages/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(         
      hintColor: Colors.white,
      primaryColor: Colors.white,
      cursorColor: Colors.white,      
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle:  TextStyle(color: Colors.white),
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.white)
      )
    ),
  ));
}