import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'Moedas/moedas.dart';

// Global API endPoin
final String endPointAPI = 'https://economia.awesomeapi.com.br/json/';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moedas',
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Moedas moedas = new Moedas();
  String selecionado;
  bool isLoading = false;
  bool isShowingList = false;

  _handlerSelectionCoin(String value){
    setState(() {
      selecionado = value;
    });
    print(selecionado);
    _handlerGetApi();
  }

  _handlerToggleIsLoading(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  _handlerGetApi() async {
    _handlerToggleIsLoading();
    Moedas temp = new Moedas();
    temp = await getAddress(selecionado);
    _handlerToggleIsLoading();

    setState(() {
      moedas = temp;
      isShowingList = true;
    });

    print(temp.low);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotação BRL'),
        actions: [
          isShowingList 
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                setState(() {
                  isShowingList = false;
                });
              }
            )
          : IconButton(
            icon: Icon(Icons.close),
            onPressed: (){              
              _showMyDialog();              
            }
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(  
        mainAxisAlignment: !isShowingList
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,             
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: !isLoading 
                    ? DropdownButton(
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      icon: Icon(Icons.attach_money_rounded),
                      hint: Text('Selecione uma opção'),
                      items: moedas.todasMoedas.map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e)
                      )).toList(),
                      onChanged: (String value) => _handlerSelectionCoin(value),
                  )
                  : SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(strokeWidth: 4,)
                  ),
                ),
                isShowingList ? Lista(minhasMoedas: moedas,) : Container(),
              ],
            ),
          ),
        ],
      ),
    );    
  }

  Future<Moedas> getAddress(String moeda) async {
    final endPoint = endPointAPI + '$moeda-BRL';
    try{
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        Flushbar(
          icon: Icon(Icons.error_outline_outlined),
          title: 'API não respondeu',
          message: 'Por favor tente novamente em alguns minutos',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        )..show(context);
        return null;
      }
      return Moedas.fromJson(response.data[0]);
    }catch(e){
      Flushbar(
          icon: Icon(Icons.error_outline_outlined),
          title: 'Erro não tratado',
          message: 'Code: $e',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        )..show(context);
    }
    return null;
  }

  Future<void> _showMyDialog() async {
     return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja Sair?'),
          content: Text("nada não"),
          actions: <Widget>[
            FlatButton(
              textColor: Color(0xFF6200EE),
              onPressed: () {exit(0);},
              child: Text('Sim'),
            ),
            FlatButton(
              textColor: Color(0xFF6200EE),
              onPressed: () {Navigator.pop(context);},
              child: Text('Não'),
            ),
          ],
        );
      },
    );
  }

}


class Lista extends StatefulWidget {
  final Moedas minhasMoedas;
  Lista({Key key, this.minhasMoedas}) : super(key: key);
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Código Entrada: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${widget.minhasMoedas.code}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Código de saída: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                Text(
                  '${widget.minhasMoedas.codein}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nome: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                Text(
                  '${widget.minhasMoedas.name}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preço Alto: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                Text(
                  '${widget.minhasMoedas.high}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preço Baixo: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                Text(
                  '${widget.minhasMoedas.low}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        ],
      );
  }
}
