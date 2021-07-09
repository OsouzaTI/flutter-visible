import 'dart:io';

import 'package:chatflutter/components/message_component.dart';
import 'package:chatflutter/screens/config_view.dart';
import 'package:chatflutter/screens/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn _googleSignIn =  GoogleSignIn();
  FirebaseUser _currentUser;
  String nickUser = "sem nick";
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentUser = user;                
      });      
      _setUserNick();
    });
  }
  
  _handlerTogglerIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentUser != null 
          ? "${_currentUser.displayName}($nickUser)"
          : "Chat Anonimo"
        ),
        elevation: 0,
        actions: [
          _currentUser != null
          ? IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){
              String _nameTemp = _currentUser.displayName;
              FirebaseAuth.instance.signOut();
              _googleSignIn.signOut();
              Flushbar(
                title: 'Usuário deslogado',
                message: '$_nameTemp deslogado com sucesso',
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              )..show(context);
            }
          )
          : IconButton(
            icon: Icon(Icons.login),
            onPressed: _getUser
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>ConfigScreen(_currentUser))
              );
            }
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("messages")
                .orderBy("time").snapshots(),
              builder: (context, snapshot) {
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
                        documents[index].data["uid"] == _currentUser?.uid
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

  void _sendMessage({String text, File image}) async {
    
    //final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final FirebaseUser user = await _getUser();
    _setUserNick();
    
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
      "time": Timestamp.now(),
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

    Firestore.instance.collection("messages").add(data);
  }

  Future<FirebaseUser> _getUser() async {

    if(_currentUser != null) return _currentUser;

    try {
      
      final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
      
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );

      final AuthResult authResult = 
        await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;

      return user;

    } catch (e) {
      print("Erro: $e");
      return null;
    }
  }

  Future<void> _setUserNick() async {
    if(_currentUser == null) return;
    DocumentSnapshot nick = await Firestore.instance
    .collection("nicks")
    .document(_currentUser.uid).get()
    .then((nick){
      if(nick.data != null){
        setState(() {
          nickUser = nick.data["nick"];
        });
      }
      return null;
    });
  }

}
