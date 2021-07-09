import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:';
// Classes imports
import 'Classes/post.dart';
// Pages imports
import 'pages/Conversor.dart';
import 'pages/banco.dart';
void main() => runApp(Myapp());

class Myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    // TODO: implement build
    return new MaterialApp(
      title: "Teste App",
      theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
} 

class _MyHomePageState extends State<MyHomePage>{
  late Timer _timer;
  late DateTime now,up;
  late String h,d,sigla,sigla2,sym,data;
  late Icon icon_;
  // Modo Offline
  bool triggerStart = true;
  bool semNet = false;
  late String path;// local do banco off
  late String off_cotacao,off_data,off_min,off_nome,off_compra,off_venda,off_variacao,off_pVariacao; // Auxiliar do banco
  late String off_cotacao_,off_data_,off_min_,off_nome_,off_compra_,off_venda_,off_variacao_,off_pVariacao_; // Retorno do banco
  //=============///
  int tela = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), atualiza);
  }
  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }
  void atualiza(Timer timer){
    setState(() {
      now = DateTime.now();
      h = DateFormat('kk:mm:ss').format(now);
      d = DateFormat('dd/MM/yyyy').format(now);
    });
  }
//=========================== BANCO ========================================//
  void _banco(int n, int k) async{
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      path = documentsDirectory.path + "/demo.db";

      // abrindo conexão
      var database = await openDatabase(path, version: 1,
        onUpgrade: (Database db, int varsion, int info) async{

        },
        onCreate: (Database db, int version) async{
          // criou então cria a tabela
          var sql1 = "CREATE TABLE dados (id integer primary key autoincrement, cotacao TEXT, data TEXT, min TEXT, nome TEXT, compra TEXT, venda TEXT, variacao TEXT, pvariacao TEXT)";
          await db.execute(sql1);
        }
      );
      var lista = await database.query("dados",
          columns: ["*"],
          where: "id=?",
          whereArgs: ['$tela'],
        );

      //============ VERIFICANDO EXISTENCIA ================//
      if(lista.length<1)
      {
        // adicionando dados
        await database.rawInsert('insert into dados(cotacao,data,min,nome,compra,venda,variacao,pvariacao) values(?,?,?,?,?,?,?,?)',
        ['$off_cotacao','$off_data','$off_min','$off_nome','$off_compra','$off_venda','$off_variacao','$off_pVariacao'],
        );
        print("Retornou vazio amigo, mas ja adicionei => $off_nome");
      }
      //============ VERIFICANDO EXISTENCIA ================//      

      if(k==1)
      {
        // update dados
        await database.rawUpdate('insert into dados(cotacao,data,min,nome,compra,venda,variacao,pvariacao) values(?,?,?,?,?,?,?,?)',
        ['$off_cotacao','$off_data','$off_min','$off_nome','$off_compra','$off_venda','$off_variacao','$off_pVariacao'],
        );
      }

    //Select
    
    for(Map<String, dynamic> i in lista)
    {      
      setState(() {
        off_cotacao_    = i['cotacao'];
        off_data_       = i['data'];
        off_min_        = i['min'];
        off_nome_       = i['nome'];
        off_compra_     = i['compra'];
        off_venda_      = i['venda'];
        off_variacao_   = i['variacao'];
        off_pVariacao_  = i['pvariacao'];
        print(i['nome']);
      });
    }
    if(n==1)
    {
      //Limpar tudo
      //await database.rawDelete("delete from dados");
      await database.rawQuery("drop table dados");
      print("tabela dropada");
    }
    if(!triggerStart)
    {
      await database.close();
      print("fechou o banco");
    }
  }    
//=========================== END BANCO ========================================//       
  Future<Post> fetchPost() async {
    // default
    Uri url = Uri.https('https://economia.awesomeapi.com.br', '/all/USD-BRL');
    sigla2 = "BRL";
    if(tela==1)
    {
      url = Uri.https('https://economia.awesomeapi.com.br', '/all/USD-BRL');
      sigla = "USD";
      icon_ = Icon(Icons.attach_money);
      sym = "\$";
    }
    else if(tela==2)
    {
      url = Uri.https('https://economia.awesomeapi.com.br', '/all/EUR-BRL');
      sigla = "EUR";
      icon_ = Icon(Icons.euro_symbol);
      sym = "\€";
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Conv. Monetário"),
      ),
      drawer: Container(
        //height: MediaQuery.of(context).size.height*0.95,
        margin: EdgeInsets.only(top:25),
        width: MediaQuery.of(context).size.height/3,
        child: Drawer(
        child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.help),
                title: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Sobre"),
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: new Text("Criado by: Ozéias\no.souzati@gmail.com\n11/06/2019 20:16",
                                    style: TextStyle(color: Color.fromRGBO(59, 89, 152, 1)),
                                  ),                                  
                                  backgroundColor: Color.fromRGBO(211, 243, 200, 1),
                                );
                              }
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Horas: $h"),
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text("Data: $d"),
              ),
              ListTile(
                leading: Icon(Icons.swap_horiz),
                title: Text("Banco Off"),
                onTap: (){                 
                  Navigator.pop(context, true);
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => banco()));
                }
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Deleta Banco Off"),
                onTap: (){
                  final dir = Directory(path);
                  dir.deleteSync(recursive: true);
                },
              ),
              ListTile(
                leading: Icon(Icons.swap_horiz),
                title: Text("Converter"),
                onTap: (){
                  Navigator.pop(context, true);
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => conversor()));
                }
              ),
              ListTile(
                leading: Icon(Icons.monetization_on, color: tela==1 ? Colors.green : Colors.grey),
                title: Text("Dollar"),
                onTap: (){
                  tela = 1;
                  new Future.delayed(const Duration(seconds: 3), (){_banco(0, 0);});
                  Navigator.pop(context, true);
                  print("tapped on container $tela");
                }
              ),
              ListTile(
                leading: Icon(Icons.monetization_on, color: tela==2 ? Colors.green : Colors.grey),
                title: Text("Euro"),
                onTap: (){
                  tela = 2;
                  new Future.delayed(const Duration(seconds: 3), (){_banco(0, 0);});
                  Navigator.pop(context, true);
                  print("tapped on container $tela");
                }
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: new FutureBuilder<Post>(
          future: fetchPost(),
          builder: (context, snapshot){            
            if (snapshot.hasData) {
              if(triggerStart)
              {
                new Future.delayed(const Duration(seconds: 5), (){_banco(0, 0);});
                triggerStart = false;
              }              
              up =  DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.date)*1000);
              String fData = DateFormat("dd:MM:yyyy").format(up);
              /// ========== POPULAÇÂO DE DADOS OFLINE =============///
              off_cotacao = snapshot.data!.maior;
              off_data = fData;
              off_min = snapshot.data!.menor;
              off_nome = snapshot.data!.name;
              off_compra = snapshot.data!.compra;
              off_venda = snapshot.data!.venda;
              off_variacao = snapshot.data!.variacao;
              off_pVariacao = snapshot.data!.p_variacao;
              ///===================================================///               
              return ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.wifi),
                    title: Text("Modo Online Ativo"),
                  ),
                  ListTile(
                    leading: Icon(Icons.trending_flat),
                    title: Text("$sigla para $sigla2"),
                  ),
                  ListTile(
                    leading: Icon(Icons.title),
                    title: Text("Moeda : ${snapshot.data!.name}"),
                  ),
                  ListTile(
                    leading: icon_,
                    title: Text("Cotação(Max) : $sym 1.00 -> R\$ ${snapshot.data!.maior}")
                  ),
                  ListTile(
                    leading: icon_,
                    title: Text("Cotação(Min) : $sym 1.00 -> R\$ ${snapshot.data!.menor}")
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text("Preço(Compra) : R\$ ${snapshot.data!.compra}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text("Preço(Venda) : R\$ ${snapshot.data!.venda}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.swap_vert),
                    title: Text("Variação(%) : ${snapshot.data!.variacao}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.swap_vert),
                    title: Text("Percent. Variação(%) : ${snapshot.data!.p_variacao}"),
                  ),
                  ListTile(
                    
                    leading: Icon(Icons.date_range),
                    title: Text("Última atualização : ${fData}"),
                  ),

                ],
              );
            } else if (snapshot.hasError) {
              if(!semNet)
              {
                _banco(0,0);
                semNet = true;
              }
              return ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.signal_wifi_off),
                    title: Text("Modo Ofline Ativo"),
                  ),
                  ListTile(
                    leading: Icon(Icons.trending_flat),
                    title: Text("$sigla para $sigla2"),
                  ),
                  ListTile(
                    leading: Icon(Icons.title),
                    title: Text("Moeda : ${off_nome_}"),
                  ),
                  ListTile(
                    leading: icon_,
                    title: Text("Cotação(Max) : $sym 1.00 -> R\$ ${off_cotacao_}")
                  ),
                  ListTile(
                    leading: icon_,
                    title: Text("Cotação(Min) : $sym 1.00 -> R\$ ${off_min_}")
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text("Preço(Compra) : R\$ ${off_compra_}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text("Preço(Venda) : R\$ ${off_venda_}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.swap_vert),
                    title: Text("Variação(%) : ${off_variacao_}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.swap_vert),
                    title: Text("Percent. Variação(%) : ${off_pVariacao_}"),
                  ),
                  ListTile(                    
                    leading: Icon(Icons.date_range),
                    title: Text("Última atualização : ${off_data_}"),
                  ),
                ],
              );
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        )
      ),
      
    );
  }

}