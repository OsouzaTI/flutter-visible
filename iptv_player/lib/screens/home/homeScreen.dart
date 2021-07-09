import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv_player/screens/Layout.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {    
    SystemChrome.setEnabledSystemUIOverlays([]);    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(),
    );
  }
}