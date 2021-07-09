import 'dart:io';

import 'package:chatflutter/components/message_component.dart';
import 'package:chatflutter/data/contact.dart';
import 'package:chatflutter/screens/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreenContact extends StatefulWidget {
  ChatScreenContact(this.user, this.contact);
  final DocumentSnapshot contact;
  final FirebaseUser user;
  @override
  _ChatScreenContactState createState() => _ChatScreenContactState();
}

class _ChatScreenContactState extends State<ChatScreenContact> {
  bool _isLoading = false;
  String get _name => widget.contact.data["name"];
  // String get _urlPhoto => widget.contact.urlPhoto;

  FirebaseUser get user => widget.user;
   
  _handlerTogglerIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                .collection("messages")
                .document(_getHashFromTwoStrings(user?.uid, widget.contact.data["friend"]))
                .collection("mymessages")
                .orderBy("time").snapshots(),
              builder: (context, snapshot) {
                _handlerSetSeeMessage();
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();                    
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,                      
                      itemBuilder: (context, index)=>MessageComponent(
                        index,
                        documents,
                        documents[index].data["uid"] == user?.uid,                        
                      ),
                    );
                }
              },
            ),
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }

  void _handlerSetSeeMessage(){
    Firestore.instance
      .collection("messages")
      .document(_getHashFromTwoStrings(user?.uid, widget.contact.data["friend"]))
      .collection("mymessages")
      .where("uid", isEqualTo: widget.contact.data["friend"])
      .getDocuments().then((value){
        value.documents.forEach((doc) {
          doc.reference.updateData({"see": true});
        });
      });
  }

  void _sendMessage({String text, File image}) async {
        
    if(user == null){
      Flushbar(
        title: 'Erro',
        message: 'Usuario não logado!',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      )..show(context);
      return null;
    }
    
    Map<String, dynamic> data = {
      "uid": user.uid,
      "sendName": user.displayName,
      "sendPhotoUrl": user.photoUrl,
      "time": FieldValue.serverTimestamp(),
      "see": false
    };

    if (image != null) {
      StorageUploadTask _task = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(image);
      
     _handlerTogglerIsLoading();
      
      StorageTaskSnapshot _taskSnapshot = await _task.onComplete;
      String url = await _taskSnapshot.ref.getDownloadURL();
      data["imageUrl"] = url;
      
      _handlerTogglerIsLoading();

    }


    if (text != null) {
      data["text"] = text;
    }

    Firestore.instance
      .collection("messages")
      .document(_getHashFromTwoStrings(user?.uid, widget.contact.data["friend"]))
      .collection("mymessages")
      .add(data);
  }

  String _getHashFromTwoStrings(String a, String b)=>"${a.hashCode + b.hashCode}";

}