import 'package:flutter/material.dart';

AlertDialog dialogAddContact(){
  return AlertDialog(
      title: Text('ID do usuario'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onSubmitted: (value){print(value);},
          )
        ],
      ),
      actions: <Widget>[
             
      ],
  );
}
