import 'package:chatflutter/components/popup_menu.dart';
import 'package:chatflutter/data/contact.dart';
import 'package:chatflutter/data/notifications.dart';
import 'package:chatflutter/screens/chat_view_contact.dart';
import 'package:chatflutter/styles/home_view_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;  
  bool _isLoading = false;

  final double statusWidth = 15;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentUser = user;                
      });      
    });
  }

  _handlerTogglerIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _handlerGetUserLogin() async {
    _currentUser = await _getUser();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLogged = _currentUser != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentUser?.displayName??"Usuário Deslogado"),
        actions: [
          IconButton(
            icon: Icon(_isLogged ? Icons.logout : Icons.login),
            onPressed: _isLogged ? _handlerSingOutUser : _handlerGetUserLogin,
          ),
          _isLogged 
          ? PopupMenu( _currentUser, _handlerAddContact)
          : IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onPressed: null
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("friends")
                        .document(_currentUser?.uid)
                        .collection("myfriends")
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                          return _listFriends(documents);
                      }
                    }
                  )
                ),
            _isLoading ? LinearProgressIndicator() : Container()
          ],
        ),
      ),
    );
  }

  void _handlerScreenContact(DocumentSnapshot contact) {    
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatScreenContact(_currentUser, contact)));
  }

  void _handlerDispatchNotification(String targetUid, Notifications notification) async {
    await Firestore.instance
      .collection("notifications")
      .document(targetUid)
      .collection("mynotifications")
      .add(notification.toMap()).then((value){
        onCompleteNotification();
        print("enviou a notificação");
      });    
  }

  void _handlerSingOutUser(){
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

  void _handlerDeleteFriend(DocumentSnapshot document) async {
    Navigator.pop(context);
    await Firestore.instance
      .collection("friends")
      .document(_currentUser.uid)
      .collection("myfriends")
      .document(document.documentID)
      .delete();
    Flushbar(
      title: 'Deletado com sucesso!',
      message: 'O usuário ${document.data["name"]} foi deletado',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  void _handlerAddContact(String name, String otherUid) async {
    _handlerTogglerIsLoading();
    await Future.delayed(Duration(seconds: 1));
    Notifications _notifications = Notifications(
      NotificationType.type_add_contact.toShortString(),
      _currentUser.displayName,
      "${_currentUser.displayName} enviou uma solicitação de amizade",
      _currentUser.uid,
      _currentUser.photoUrl
    );
    _handlerDispatchNotification(otherUid, _notifications);
    _handlerTogglerIsLoading();
  }

  Future<FirebaseUser> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;

      return user;
    } catch (e) {
      print("Erro: $e");
      return null;
    }
  }

  void onCompleteAddContact(value) {
    Navigator.pop(context);
    Flushbar(
      title: 'Agora vocês são amigos',
      message: 'O contato aparecerá na tela inical',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    )..show(context);    
  }

  void onErrorAddContact(onError) {
    Navigator.pop(context);
    if (onError.message == "PERMISSION_DENIED: Missing or insufficient permissions.") {
      Flushbar(
        title: 'Contato já adicionado',
        message: 'Provavelmente esse contato já está adicionado...',
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      )..show(context);
    }
  }

  void onCompleteNotification(){
    Navigator.pop(context);
    Flushbar(
      title: 'Notificação enviada',
      message: 'Aguarde o contato aceitar sua solicitação',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    )..show(context);   
  }

  Future<void> _showDeleteFriend(DocumentSnapshot document){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context){
        return AlertDialog(
            title: Text('Deletar ?'),
            content: Text("Deseja deletar esse usuário"),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=>_handlerDeleteFriend(document),
                child: Text("Sim")
              ),
              FlatButton(
                onPressed: ()=>Navigator.pop(context),
                child: Text("Não")
              ),
            ],
        );
      }  
    );
  }

  Widget _listFriends(List<DocumentSnapshot> documents){    
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      backgroundImage: documents[index].data["photoUrl"] != null
                        ? NetworkImage(documents[index].data["photoUrl"])
                        : AssetImage("assets/macaco.png"),
                    ),
                    StreamBuilder(
                      stream: _streamMessage(documents[index].data["friend"]),
                      builder: (context, snapshot){
                        if(snapshot.hasData){                          
                          List<DocumentSnapshot> documents = snapshot.data.documents;  
                          return Container(
                            width: statusWidth,
                            height: statusWidth,
                            decoration: BoxDecoration(
                              color: documents.length != 0 ? Colors.green : Colors.red,
                              borderRadius:  BorderRadius.all(Radius.circular(statusWidth * 0.5))
                            ),
                            child: Center(child: Text(documents.length != 0 ? documents.length.toString() : "0")),
                          );
                        }else {
                          return Container(
                            width: statusWidth,
                            height: statusWidth,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:  BorderRadius.all(Radius.circular(statusWidth * 0.5))
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    documents[index].data["name"],
                    style: nameFriends(),
                  ),
                )
              ],
            ),
          ),
          onTap: () => _handlerScreenContact(documents[index]),
          onLongPress: () => _showDeleteFriend(documents[index]),
        );
      });
  }
  
  String _getHashFromTwoStrings(String a, String b)=>"${a.hashCode + b.hashCode}";
  Future<String> _handlerGetMessagesSee(String otherUid) async {
    // print(_currentUser.uid);
    print(otherUid);
    // print(_getHashFromTwoStrings(_currentUser.uid, otherUid));
    QuerySnapshot snapshot = await Firestore.instance
      .collection("messages")
      .document(_getHashFromTwoStrings(_currentUser.uid, otherUid))
      .collection("mymessages")      
      .where("see", isEqualTo: false)
      .where("uid", isEqualTo: otherUid)
      .getDocuments();
      
      // print(snapshot.documents.first.data["sendName"]);
    
    return snapshot.documents.length.toString();   

  }

  Stream _streamMessage(String otherUid){
    return Firestore.instance
      .collection("messages")
      .document(_getHashFromTwoStrings(_currentUser.uid, otherUid))
      .collection("mymessages")
      .where("see", isEqualTo: false)
      .where("uid", isEqualTo: otherUid)
      .snapshots();
  }

}
