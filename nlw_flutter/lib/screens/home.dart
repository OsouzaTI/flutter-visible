import 'package:flutter/material.dart';

class Home extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NLW ain 8======D"),),
      body: Center(
        child: Container(
          child: Text("Curso", style: getStyle(),),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
    );
  }
}

TextStyle getStyle(){
  double sizeFont = 30;
  return TextStyle(
    fontSize: sizeFont,
    color: Colors.grey
  );
}