import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Cep App v.01'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  //final myStore = MyHomePageStore();
  final _formKey = GlobalKey<FormState>();
  CepModel cepModel = CepModel('', '', '', '', '', '', '', '', '', '');
  bool isLoading = false;
  Future<CepModel> getAddress(String cep) async {
    try {
      final String endPoint = 'https://viacep.com.br/ws/$cep/json/';
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.data['erro'] != null){
        Flushbar(
          title: 'Erro',
          message: 'CEP invalido!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        )..show(context);
        return null;
      }
      return CepModel.fromJson(response.data);
    } catch (e) {
      print('$e');
    }
    return null;
  }

  _handlerSearchAddress(String value) async {
    if(_formKey.currentState.validate()){
      _toggleIsLoading();
      CepModel cep = await getAddress(value); 
      _toggleIsLoading();
      if(cep == null) return;
      setState((){
        cepModel.logradouro = cep.logradouro;
        cepModel.bairro = cep.bairro;
        cepModel.localidade = cep.localidade;
        cepModel.uf = cep.uf;
      });
    }
  }

  _toggleIsLoading(){
    setState((){
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title)
          ],
        ),
      ),
      body: Form(        
          key: _formKey,
          child: Column(           
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                onFieldSubmitted: _handlerSearchAddress,  
                textInputAction: TextInputAction.done,
                validator: (value){
    
                  if(value.isEmpty){
                    return 'Digite algum valor';
                  }else if(value.length < 8){
                    return 'Cep tem 8 digitos';
                  }else if(value.length > 8){
                    return 'Cep muito grande';
                  }
                  
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Digite um CEP'
                ),
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Expanded(
                      child: FlatButton(
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: isLoading 
                        ? CircularProgressIndicator(
                        strokeWidth: 3,
                        backgroundColor: Colors.white,
                      ) : Text('Procurar CEP'),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){}
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Logradouro',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    cepModel?.logradouro ?? '',
                    style: TextStyle(                    
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bairro',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    cepModel?.bairro ?? '',
                    style: TextStyle(                    
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cidade',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    cepModel?.localidade ?? '',
                    style: TextStyle(                    
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    cepModel?.uf ?? '',
                    style: TextStyle(                    
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CepModel {
  String cep;
  String logradouro;
  String complemento;
  String bairro;
  String localidade;
  String uf;
  String ibge;
  String gia;
  String ddd;
  String siafi;

  CepModel(
    cep,
    logradouro,
    complemento,
    bairro,
    localidade,
    uf,
    ibge,
    gia,
    ddd,
    siafi
  );

  CepModel.fromJson(Map<String, dynamic> json){
    cep = json['cep'] ?? '';
    logradouro = json['logradouro'] ?? '';
    complemento = json['complemento'] ?? '';
    bairro = json['bairro'] ?? '';
    localidade = json['localidade'] ?? '';
    uf = json['uf'] ?? '';
    ibge = json['ibge'] ?? '';
    gia = json['gia'] ?? '';
    ddd = json['ddd'] ?? '';
    siafi = json['siafi'] ?? '';
  }

}