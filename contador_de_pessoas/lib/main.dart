import 'dart:math';
import 'package:flutter/material.dart';

// Globais
int r, g, b;

void main(List<String> args) {  
  runApp(MaterialApp(
    title: "Contador de pessoas",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  void mudaCor(){
    setState((){
      r = Random().nextInt(255);
      g = Random().nextInt(255);
      b = Random().nextInt(255);    
      print("R $r - G $g - B $b");
    });
  }

  @override  
  Widget build(BuildContext context){
    mudaCor(); // chamando função ao menos uma vez
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cores Aleatorias"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.replay_outlined),
            onPressed: ()=>mudaCor(),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, r, g, b),                
        child: Center(
          child: Text('R ${r} - G ${g} - B ${b}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold
              ),
            ),        
        )
      ),
    );   
    
  }

}