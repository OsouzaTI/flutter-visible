import 'package:flutter/material.dart';
import 'package:yamete_manga/screens/home.dart';

void main(){
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(    
      appBarTheme: AppBarTheme(
        color: const Color(0xFF010608),        
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 20
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20
          )
        )
      ),     
      hintColor: Colors.white,
      primaryColor: Colors.white,
      cursorColor: Colors.white,            
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle:  TextStyle(color: Colors.white),
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.white)
      ),
      
    ),
  ));
}