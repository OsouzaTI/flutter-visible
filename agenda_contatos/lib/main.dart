import 'package:agenda_contatos/screens/home_view.dart';
import 'package:flutter/material.dart';

const Color blackColor = Color(0xFF000000);
const Color greyColor21 = Color(0xFF212121);
const Color greyColor63 = Color(0xFF3f3f3f);
const Color greyColor80 = Color(0xFF505050);


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(
      primaryColor: greyColor21,
      cardColor: greyColor80,
      scaffoldBackgroundColor: greyColor21,
      accentColor: blackColor,
      popupMenuTheme: PopupMenuThemeData(
        // color: Colors.white,
        textStyle: TextStyle(
          color: Colors.white
        )
      ),      
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.white
        ),    
        bodyText2: TextStyle(
          color: Colors.white
        ),
        headline1: TextStyle(
          color: Colors.white
        ),    
        subtitle1: TextStyle(
          color: Colors.white
        ),    
        subtitle2: TextStyle(
          color: Colors.white
        ),   

      ),
      inputDecorationTheme: InputDecorationTheme(    
        // alignLabelWithHint: true,
        border:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),        
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        hintStyle: TextStyle(
          color: Colors.white,          
        ),
        helperStyle: TextStyle(
          color: Colors.white
        ),
        labelStyle: TextStyle(
          color: Colors.white
        ),
      )
    ),
  ));
}