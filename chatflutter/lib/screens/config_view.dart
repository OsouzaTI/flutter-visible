import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  ConfigScreen(this.currentUser);
  final FirebaseUser currentUser;
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.text_format, color: Colors.white,),
              title: Text("Mudar Apelido"),
              onTap: _changeNamePopup,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _changeNamePopup(){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Novo nome'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onSubmitted: _handlerChangeName,
              )
            ],
          ),
          actions: <Widget>[
            Text('version-dubug v0.1'),           
          ],
        );
      },
    );
  }

  void _handlerChangeName(String name) async {
    Navigator.pop(context);
    
    if(widget.currentUser == null){
      Flushbar(
        title: 'Faça login',
        message: 'Antes de alterar seu nick, entre com seu email',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      )..show(context);
      return null;
    }else if(name.isEmpty){
      Flushbar(
        title: 'Texto vazio',
        message: 'Escreva algo ex:("teu pai de calcinha")',
        backgroundColor: Colors.yellow,
        duration: Duration(seconds: 2),
      )..show(context);
      return null;
    }

    await Firestore.instance
      .collection("nicks")
      .document(widget.currentUser.uid).setData({
        "nick": name
      });
      
    Flushbar(
      title: 'Nick modificado com sucesso',
      message: '$name agora é seu apelido',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    )..show(context);


  }

}