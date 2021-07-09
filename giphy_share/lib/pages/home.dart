import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_share/pages/giphy.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import '../api/end_point.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EndPoint _endPoints = new EndPoint();
  String _search;
  int _offset = 0;

  @override
  void initState() {    
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    //_getGiphys().then((map) => print(map));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('./images/header.gif'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white,size: 30,),
            onPressed: _showMyDialog,
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(                
                labelText: "Pesquisar Giphy",
                labelStyle:  TextStyle(
                  color: Colors.white,
                  fontSize: 18,                                
                ),                
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text){
                setState(() {
                  _search = text;
                });
              },
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGiphys(),
              builder: (context, snapshot){
                switch(snapshot.connectionState)
                {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if(snapshot.hasError){
                      Flushbar(
                        title: 'Erro',
                        icon: Icon(Icons.error),
                        message: 'Erro ao carregar giphys',
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      )..show(context);
                      return Container();
                    }else{
                      return _createGiphyTable(context, snapshot);
                    } 
                }
              },
            )
          )
        ],
      ),
    );
  }

  Future<Map> _getGiphys() async {
    http.Response response;

    if(_search == null || _search.isEmpty){
      print(_endPoints.getEndPointTrending(20));
      response = await http.get(_endPoints.getEndPointTrending(20));
    }else{
      response = await http.get(_endPoints.getEndPointSearch(_search, 19, _offset));
    }

    return json.decode(response.body);

  }

  int _getCount(List data){
    if(_search == null) return data.length;
    else return data.length + 1;
  }
  
  Widget _createGiphyTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
        if(_search == null || index < snapshot.data["data"].length){
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),    
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> GiphyPage(snapshot.data["data"][index]))
              );
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },   
          );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 70,),
                  Text(
                    "Carregar mais",
                    style: TextStyle(color: Colors.white, fontSize: 20)
                  ),
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            ),            
          );
        }
      }
    );
  }

  Future<void> _showMyDialog() async {
     return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dicas', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          content: Text("Você pode segurar o click em um giphy e compartilha-lo"),
          actions: <Widget>[
            Text('version-dubug v0.1'),           
          ],
        );
      },
    );
  }

}