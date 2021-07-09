import 'dart:ui';
import 'package:chatflutter/screens/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class MessageComponent extends StatefulWidget {
  MessageComponent(this.index, this.documents, this.mine);
  final int index;
  final List<DocumentSnapshot> documents;
  final bool mine;  

  @override
  _MessageComponentState createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  
  int get index => widget.index;  
  List<DocumentSnapshot> get documents => widget.documents;  
  String otherNick;

  String get nameUser => documents[index].data["sendName"];

  @override
  void initState() {    
    super.initState();
    _getUserNick(documents[index].data["uid"]);
  }

  // Time configs
  final DateFormat formatter = DateFormat('hh:mm');  
  
  String get formatted =>
    documents[index].data["time"] != null
    ? formatter.format(
      DateTime.fromMillisecondsSinceEpoch(
        documents[index].data["time"].seconds * 1000
      )
    ) : "...";   

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0
      ),          
      child: Container(
        constraints: BoxConstraints(
          minWidth: 0.0,
          maxWidth: 200,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(          
          borderRadius: BorderRadius.all(Radius.circular(5.0)),          
        ),
        child: widget.mine 
        ? messageUser()
        : messageOther(),
      )
    );
  }

  TextStyle messageStyle(){
    return TextStyle(
      fontSize: 16,
    );
  }
  
  TextStyle userLabel(){
    return TextStyle(
      fontSize: 13,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _userLabelSpan(String text){    
    return Container(
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: widget.mine ? Color(0xCB4CAF50) : Color(0xCBfbea0f),
      ),
      child: Text(text, style: userLabel(),),
    );
  }

  Widget _imageContainer(String url){
    return GestureDetector(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: url,
        width: 200,
        height: 300,
        fit: BoxFit.cover,
      ),
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context)=>PhotoScreen(url))
        );
      },
    );
  }

  Widget messageUser(){
    return Row(    
        crossAxisAlignment: CrossAxisAlignment.end,    
        children: [
          Text(formatted),          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(              
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _userLabelSpan(nameUser),                    
                  documents[index].data["imageUrl"] != null
                  ? _imageContainer(documents[index].data["imageUrl"])
                  : _message(documents[index].data["text"]),
                ],
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                documents[index].data["sendPhotoUrl"]
              ),
            ),
          ),
        ],
    );
  }

  Widget messageOther(){
        return Row(    
        crossAxisAlignment: CrossAxisAlignment.end,        
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                documents[index].data["sendPhotoUrl"]
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(              
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _userLabelSpan(nameUser),                    
                  documents[index].data["imageUrl"] != null
                  ? _imageContainer(documents[index].data["imageUrl"])
                  : _message(documents[index].data["text"]),
                ],
              ),
            )
          ),            
          Text(formatted), 
        ],
    );
  }

  Widget _message(String message){
    return Container(
      child: Text(
        message,
        style: messageStyle(),
        textAlign: widget.mine ? TextAlign.end : TextAlign.start,),
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.all(8.0),
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width/2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.purple[900]
      ),
    );
  }

  Future<void> _getUserNick(String uid) async {
    if(widget.mine) return;

    DocumentSnapshot nick = await Firestore.instance
      .collection("nicks")
      .document(uid).get()
      .then((nick){
        if(nick.data != null){
          setState(() {
            otherNick = nick.data["nick"];      
          });
        }
        return null; 
      });

  }

}