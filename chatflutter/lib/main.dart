import 'package:chatflutter/screens/home_view.dart';
import 'package:flutter/material.dart';

void main() {

  // ROXO BACKGROUND 2A1847
  // AMARELO FFE600
  // ROXO HEADER 711C99
  Color colorScaffold = Color(0xFF2A1847);
  Color colorIcons = Color(0xFFfbea0f);
  Color colorHeader = Color(0xFF711C99);


  runApp(MaterialApp(
    title: "Chat flutter",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // primarySwatch: Colors.orange,
      primaryColor: colorHeader, 
      scaffoldBackgroundColor: colorScaffold,      
      primaryIconTheme:  IconThemeData(
        color: colorIcons,  
        size: 40      
      ),
      accentIconTheme: IconThemeData(
        color: colorIcons,  
        size: 40      
      ),
      iconTheme: IconThemeData(
        color: colorIcons,  
        size: 40      
      ),
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white
        ),
        subtitle1: TextStyle(
          color: Colors.white
        ),
        
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorHeader,
        elevation: 3,        
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 3,
        color: Colors.purple,
        textStyle: TextStyle(
          color: Colors.white
        )
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.purple,
        contentTextStyle: TextStyle(
          color: Colors.white
        ),
        elevation: 2,
        titleTextStyle: TextStyle(
          color: Colors.white
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.white
        ),
        hintStyle: TextStyle(
          color: Colors.white
        )
      ),
    ),
    home: HomeScreen(),
  ));

  // Firestore.instance
  //   .collection("col")
  //   .document("doc")
  //   .setData({"Texto": "ozeias"});
    
}