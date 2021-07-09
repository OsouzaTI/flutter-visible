import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iptv_player/core/app_colors.dart';
import 'package:iptv_player/data/db.dart';
import 'package:iptv_player/mobx/main_model.dart';
import 'package:iptv_player/screens/home/homeScreen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool existList = false;
  MainModel model;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    model = Provider.of<MainModel>(context);
      
    final data = await readData();

    if(data != null){
      setState(() {existList = true;});
      final map = json.decode(data);
      model.setGroupChannels(map);
      print("existe lista!");
      print(map);
    }
    _handlerHomePage();
    
  }

  _handlerHomePage(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context)=>Home())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C3A55),
      body: Center(
        child: !existList 
          ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          )
          : Container(),
      ),
    );
  }
}