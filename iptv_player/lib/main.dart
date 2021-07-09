import 'package:flutter/material.dart';
import 'package:iptv_player/mobx/main_model.dart';
import 'package:iptv_player/screens/splash/splashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<MainModel>(
        create: (_)=>MainModel(),
      )
    ],
    child: MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    )

  ));
}