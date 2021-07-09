import 'package:chatflutter/components/dialog_add_contact.dart';
import 'package:chatflutter/screens/notifications_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

enum PopupMenuType {
  add_contact,
  notifications,
  copy_uid,
  exit
}

class PopupMenu extends StatefulWidget {
  PopupMenu(this.user, this.addContact);  
  FirebaseUser user; 
  final Function(String, String) addContact;
  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupMenuType>(
      itemBuilder: (context) => <PopupMenuEntry<PopupMenuType>>[
        const PopupMenuItem<PopupMenuType>(
          child: Text("Adicionar Amigo"),
          value: PopupMenuType.add_contact,
        ),
        const PopupMenuItem<PopupMenuType>(
          child: Text("Notificações"),
          value: PopupMenuType.notifications,
        ),
        const PopupMenuItem<PopupMenuType>(
          child: Text("Copiar UID"),
          value: PopupMenuType.copy_uid,
        ),
        const PopupMenuItem<PopupMenuType>(
          child: Text("Sair"),
          value: PopupMenuType.exit,
        )
      ],
      onSelected: (PopupMenuType type){
        switch(type){
          case PopupMenuType.add_contact:
            _changeNamePopup(dialogAddContact());
            break;
          case PopupMenuType.copy_uid:
            FlutterClipboard.copy(widget.user.uid).then((value){
              Flushbar(
                title: 'Seu UID foi Copiado',
                message: 'Compartilhe seu UID com outra pessoa',
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              )..show(context);
            });
            break;
          case PopupMenuType.notifications:
            _handlerGoNotificationsPage();
            break;
          default: print(type);
        }
      },
    );
  }

  Future<void> _changeNamePopup(AlertDialog alert){
    TextEditingController _name = TextEditingController();
    TextEditingController _uid = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context){
        return AlertDialog(
            title: Text('ID do usuario'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(        
                  decoration: InputDecoration(
                    hintText: "Nome do usuario"
                  ),          
                  controller: _name,
                ),                
                TextField(         
                  decoration: InputDecoration(
                    hintText: "UID do usuario"
                  ), 
                  controller: _uid,        
                ),                
                FlatButton(
                  onPressed: (){
                    if(_name != null && _uid != null && _name.text != "" && _uid.text != ""){
                      widget.addContact(_name.text, _uid.text);
                    }
                  },
                  child: Text("Adicionar", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            actions: <Widget>[
                  
            ],
        );
      },
    );
  }

  void _handlerGoNotificationsPage(){
    Navigator.push(context,
     MaterialPageRoute(builder: (context)=>NotificationScreen(widget.user))
    );
  }

}