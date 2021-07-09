import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:yamete_winx/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MultiProvider(
    // create: (_) => MainModel(),
    providers: [
      Provider<MainModel>(
        create: (_)=>MainModel(),
      )
    ],
    child: OverlaySupport.global(
      child: MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  ));

  doWhenWindowReady(() {
    final win = appWindow;
    final initialSize = Size(860, 640);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });

}