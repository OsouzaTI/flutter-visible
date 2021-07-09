import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen(this.myUser);
  final FirebaseUser myUser;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificações"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
            .collection("notifications")
            .document(widget.myUser.uid)
            .collection("mynotifications")
            .snapshots(),
          builder: (context, snapshot){
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                return _listNotifications(documents);
            }
          },
        ),
      ),
    );
  }

  Widget _listNotifications(List<DocumentSnapshot> documents){    
    double iconSize = 32;
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index){
        bool _typeNotification = documents[index].data["type"] == "type_add_contact";
        return ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: _typeNotification 
            ? Icon(Icons.add_circle, color: Colors.green, size: iconSize,)
            : Icon(Icons.notifications, color: Colors.green, size: iconSize),
            title: Text(documents[index].data["title"]),
            subtitle: 
            _typeNotification
            ? Row(
              children: [
                FlatButton(
                  onPressed: ()=>_handlerAcceptFriend(documents[index]),
                  child: Text("Aceitar", style: TextStyle(color: Colors.greenAccent),)
                ),
                FlatButton(
                  onPressed: null,
                  child: Text("Rejeitar", style: TextStyle(color: Colors.redAccent),)
                ),
              ],
            ) : Container(),
        );
      }
    );
  }

  void _handlerAcceptFriend(DocumentSnapshot document) {
    Firestore.instance
      .collection("friends")
      .document(widget.myUser.uid)
      .collection("myfriends")
      .add({
        "friend": document.data["uid"],
        "name": document.data["name"],
        "photoUrl": document.data["photoUrl"]
      });

    Firestore.instance
      .collection("friends")
      .document(document.data["uid"])
      .collection("myfriends")
      .add({
        "friend": widget.myUser.uid,
        "name": widget.myUser.displayName,
        "photoUrl": widget.myUser.photoUrl
      });

    Firestore.instance
      .collection("notifications")
      .document(widget.myUser.uid)
      .collection("mynotifications")
      .document(document.documentID)
      .delete().then((value){
        Flushbar(
          title: 'Agora vocês são amigos',
          message: 'O contato aparecerá na tela inical',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        )..show(context);    
      });

  }

}