import 'package:flutter/material.dart';
import 'package:yamete_anime/mobx/main_model.dart';
import 'package:yamete_anime/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:yamete_anime/windows_configuration.dart';

void main() {
  
  runApp(
    MultiProvider(
      providers: [
        Provider<MainModel>(
          create: (_)=>MainModel(),
        )
      ],
      child: MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      )  
    )
  );
  
  WindowsConfigs.windowsConfig();

}
