import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class banco extends StatefulWidget {
  @override
  _bancoState createState() => _bancoState();
}

class _bancoState extends State<banco> {
  var data = [];
  int count = 1;
  bool triggerStart = true;
  bool dataSucsses = false;
  //=========================== BANCO ========================================//
  void _banco() async{
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = documentsDirectory.path + "/demo.db";

      // abrindo conexão
      var database = await openDatabase(path, version: 1,
        onUpgrade: (Database db, int varsion, int info) async{

        },
        onCreate: (Database db, int version) async{
          // criou então cria a tabela
          var sql1 = "CREATE TABLE dados (id integer primary key autoincrement, cotacao TEXT, data TEXT, min TEXT, nome TEXT)";
          await db.execute(sql1);
        }
      );

      //Select
    
      var lista = await database.query("dados",
      columns: ["*"],
      );
     
      for(Map<String, dynamic> i in lista)
      {
        setState(() {
          var id = i['id'].toString();
          data.add(
           'id: '+id                +'\n'
          +'cotação(max): '+i['cotacao'] +'\n'
          +'Moeda: '+i['nome']      +'\n'
          +'cotação(min): '+i['min']+'\n'
          +'preço(compra): '+i['compra']+'\n'
          +'preço(venda): '+i['venda']+'\n'
          +'variação(% eu acho): '+i['variacao']+'\n'
          +'Perc. Variação(%): '+i['pvariacao']+'\n'
          +'Ultima atualização: '+i['data']+'\n'
          );          
        });
      }
     
    count = lista.length;
    dataSucsses = true;
    await database.close();
  }    
//=========================== END BANCO ========================================// 

  @override
  
  Widget build(BuildContext context) {
    if(triggerStart){
      _banco();
      triggerStart = false;
    }
    return Container(      
      child: Scaffold(
        appBar: AppBar(
          title: Text("ola"),
        ),
        body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index){
            if(dataSucsses)
            {
              return ListTile(
                title: Text("${data[index]}"),
              );
            }
            
            return Container(
              height: MediaQuery.of(context).size.height/2+25,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
              padding: EdgeInsets.all(100),
              child: CircularProgressIndicator(),
            );

          },
        ),
      )
    );
  }
}