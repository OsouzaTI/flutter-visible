
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import '../Classes/post.dart';
import '../main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class conversor extends StatefulWidget {
  @override
  _conversorState createState() => _conversorState();
}

class _conversorState extends State<conversor> {
  int id_ = 1;
  String valor = "USD";
  var cotacao;
  var resp = 0.0;
  final f_resp = new NumberFormat('#.###');
  String sigla = "-";
  String sym = "\$";
  final reais = TextEditingController();


  Future<Post> fetchPost() async {
    // default
    Uri url = Uri.https('https://economia.awesomeapi.com.br','/all/USD-BRL');
    if(id_==1)
    {
      url = Uri.https('https://economia.awesomeapi.com.br','/all/USD-BRL');
      sigla = "USD";
    }
    else if(id_==2)
    {
      url = Uri.https('https://economia.awesomeapi.com.br', '/all/EUR-BRL');
      sigla = "EUR";
    }

    final response = await http.get(url, headers: {"Accept": "aplication/json"});

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var data = jsonDecode(response.body);
      return Post.fromJson(data['$sigla']);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Conv. Monetário"),
        ),
        body: Column( // ================
          children: <Widget>[
            Row(
              children: <Widget>[
                Column( // COLUMN 1 ====================================== >
                  children: <Widget>[
                    Container(
                      //color: Colors.lightBlue,
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width/2,
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                width: 50,
                                child: Text("R\$"),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Reais"
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: reais,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    )
                  ],
                ),
                Column( // COLUMN 2 ====================================== >
                  children: <Widget>[
                    Container(
                      //color: Colors.red,
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width/2,
                      child: DropdownButton(
                      // value: valor,
                        //value: "USD",
                        items: <String>['USD','EUR'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint: Text("$valor"),
                        onChanged: (String? value){
                          print("Mudou");
                          if(value == null) return;
                          valor = value;
                          resp = 0;
                          setState(() {
                            if(valor=="USD"){
                              id_ = 1;
                              sym = "\$";
                            }
                            else
                            {
                              id_ = 2;
                              sym = "\€";
                            }
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[                
                Column(
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/4),
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      color: Color.fromRGBO(0, 160, 176, 0.1),
                      child: FutureBuilder<Post>(
                        future: fetchPost(),
                        builder: (context, snap){
                          if(snap.hasData){
                            String apoio = snap.data!.maior;
                            apoio = apoio.replaceAll(',', '.');
                            cotacao = double.tryParse(apoio);
                            return Text("Cotação: R\$ $cotacao", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16,color: Colors.grey),);
                          }else if (snap.hasError) {
                            return Text("Tente novamente mais tarde.");
                          }
                          return Text("Carregando...", textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16,color: Colors.red));
                        },
                      )
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/4),
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      color: Color.fromRGBO(0, 160, 176, 0.5),                    
                      child: Text("R\$ ${reais.text} => $sym ${f_resp.format(resp)}",
                      textAlign: TextAlign.left,style: TextStyle(fontSize: 16,
                      color: Colors.white),),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Column(// COLUMN 1 ====================================== >
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/4),
                      padding: EdgeInsets.all(10),
                      //color: Colors.lightBlue,
                      width: MediaQuery.of(context).size.width/2,
                      child: FutureBuilder<Post>(
                        future: fetchPost(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){                                
                            print("Data push complete");
                            return FlatButton(
                              color: Color.fromRGBO(153, 217, 223, 0.5),
                              child: Text("Calcular"),
                              onPressed: (){
                                setState(() {                                
                                  var val = double.tryParse(reais.text);
                                  if(val==null){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: new Text("Valor incorreto!"),
                                        );
                                      }
                                    );
                                  }else{
                                    resp = val / cotacao;                                              
                                    print("${f_resp.format(resp)}"); 
                                  }
                                });
                              },
                            );
                          }
                          else if (snapshot.hasError) {
                            return Text("Tente novamente mais tarde.");
                          }
                          // By default, show a loading spinner
                          return LinearProgressIndicator();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}