import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yamete_manga/components/C_MangaCard.dart';
import 'package:yamete_manga/data/D_Manga.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataAllMangas _mangas = new DataAllMangas();
  List<String> tags = ["Ultimos Lançamentos", "Mais Populares", "Ultimos Adicionados", "Favoritos"];
  bool _calledApi = false;
  bool _isFavorites = false;  
  bool _isLoading = false;
  bool _isSearch = false;
  List _favorites = [];
  TextEditingController _controller = new TextEditingController();
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    ///_handlerGetAllMangas();
    // _focus.addListener(_handlerOnFocusChange);
    SystemChrome.setEnabledSystemUIOverlays([]);
    _readData().then((data){      
      setState(() {
        if(data != null){
          _favorites = json.decode(data);
          print(_favorites);
        }
      });   
    });

  }

  /* START HANDLERS */

  /* Handler para o foco das  */

  // _handlerOnFocusChange(){
  //   if(!_focus.hasFocus){
  //     setState(() {
  //       _isSearch = false;
  //     });
  //   }
  // }

  _handlerGetAllMangas() async {
    setState(() {
      _calledApi = true;
    });
    _handlerToggleIsLoading();
    _mangas = await _getAllMangas();
    if(_mangas != null){
      _handlerSetFavorites();
      _handlerToggleIsLoading();      
    }
  }

  _handlerGetAllMangasSearch(String search) async {
    // setState(() {
    //   _isSearch = false;
    // });
    // _controller.clear();
    // DataAllMangas temp;
    // _handlerToggleIsLoading();
    // temp = await _getAllMangasSearch(search);
    // if(temp != null){
    //   setState(() {
    //     _dropDownValue = 4;
    //     _mangas = temp;        
    //   });
    //   _handlerToggleIsLoading();
    // }
  }

  _handlerGetAllFavorites(){
    _handlerToggleIsLoading();
    _readData().then((data){
      if(data != null){
        setState(() {
          _favorites = json.decode(data);
          _handlerSetFavorites();
        });   
      }else{
        print(data);
      }
    });
    _handlerToggleIsLoading();
  }

  _handlerToggleIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _handlerTogglerIsSearch(){
    setState(() {
      _isSearch = !_isSearch;
    });
  }
  
  _handlerTogglerIsFavorites() async {
    // if(_isFavorites){
    //   if(_mangas.mangas.length == 0){
    //     await _handlerGetAllMangas();
    //   }else{
    //     _showMyDialog();
    //   }
    // }
    setState(() {
      _isFavorites = !_isFavorites;
    });
  }

  _handlerSetFavorites(){
    _favorites.forEach((favorite) {
      int test = _mangas.mangas.indexWhere((manga) => manga.name == favorite["name"]);
      if(test != -1){
        _mangas.mangas[test].isFavorite = true;
      }
    });
  }

  _handlerSaveFavorite(String title, String img, String link) async {    
    Map<String, dynamic> manga = Map();
    manga["name"] = title;
    manga["img"] = img;
    manga["link"] = link;
    manga["isFavorite"] = true;
    _favorites.add(manga);
    _saveData();
    _handlerGetAllFavorites();
  }

  /* END HANDLERS */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yamete Mangá'),
        centerTitle: false,
        backgroundColor: const Color(0xFF010608),
        actions: [
          FlatButton(
            onPressed: _handlerTogglerIsFavorites,
            child: Text("Favorites", style: TextStyle(
              color: _isFavorites ? Colors.green : Colors.white
            ),)
          ),
          AnimatedCrossFade(
            crossFadeState: !_isSearch
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 200),                        
            firstChild: buttonSearch(),
            secondChild: textFieldSearch(),
          )
        ],
      ),
      body: Container(
        color: const Color(0xFF18343B),
        child: Column(
          children: [
            Expanded(
              child: Container(
              padding: EdgeInsets.all(5),
              child: _isLoading
                ? Center(child: CircularProgressIndicator(),)          
                : gridViewBuilder(),
              ),
            ),          
          ],
        ),
      ),
    );
  }

  Widget buttonSearch(){
    return IconButton(
      icon: Icon(Icons.search,),
      onPressed: _handlerTogglerIsSearch,
    );
  }

  Widget textFieldSearch(){
    return Center(
      child:Container(                 
          child: Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  width: 200,
                  height: 40,                
                  child: TextField(          
                    controller: _controller,
                    textInputAction: TextInputAction.done,                                      
                    onSubmitted: _handlerGetAllMangasSearch,    
                    focusNode: _focus,                       
                    style: TextStyle(
                      color: Colors.white,     
                      fontSize: 20                   
                    ),             
                    decoration: InputDecoration(                
                      contentPadding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0),
                    ),
                  ),                
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red,),        
                  onPressed:  _handlerTogglerIsSearch,
                ),
              ],
            ),
          ),          
        ),        
      );
  }

  Widget gridViewBuilder(){    
    return !_isFavorites
      ? Container(
        child: !_calledApi
          ? Center(
            child: FlatButton(
              onPressed: _handlerGetAllMangas,
              child: Text("Carregar mangás", style: TextStyle(color: Colors.white, fontSize: 20),)),)
          : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 0.7,
            ),
            itemCount: _mangas.mangas?.length ?? 0,
            itemBuilder: (context, gridIndex){
              String title = _mangas.mangas[gridIndex].name ?? '';
              String img = _mangas.mangas[gridIndex].img ?? '';
              String link = _mangas.mangas[gridIndex].link ?? '';
              bool favorite = _mangas.mangas[gridIndex].isFavorite ?? false;
              return CMangaCard(title, img, link, favorite, _handlerSaveFavorite);            
          }),
      )
      : Container(
        child: _favorites.length > 0
          ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 0.7,
            ),
            itemCount: _favorites.length,          
            itemBuilder: (context, gridIndex){
              // print(_favorites[gridIndex]);
              String title = _favorites[gridIndex]["name"];
              String img = _favorites[gridIndex]["img"];
              String link = _favorites[gridIndex]["link"];   
              bool favorite = _favorites[gridIndex]["isFavorite"];     
              return GestureDetector(
                child: CMangaCard(title, img, link, favorite, _handlerSaveFavorite),
                onLongPress: (){
                  _favorites.removeAt(gridIndex);
                  _saveDataRemoving(title);
                  _handlerGetAllFavorites();
                },
              );
        })
        :Center(
          child: Text(
            "Você não possui mangás salvos," +
            "por favor clique em 'favoritos' e escolha",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,              
            ),
            
            ),
        ),
      );
  }

  Future<DataAllMangas> _getAllMangas() async {
    //final endPoint = "https://api.jsonbin.io/b/5fde0780e042aa6103e34582";
    final endPoint = "https://yamete-manga.herokuapp.com/listar";
    try {
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
      return DataAllMangas.fromJson(response.data);
    } catch (e) {
      Flushbar(
        icon: Icon(Icons.error_outline_outlined),
        title: 'Erro não tratado',
        message: 'Code: $e',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      )..show(context);
      return null;
    }
  }

  // Future<DataAllMangas> _getAllMangasSearch(String search) async {
  //   final endPoint = "https://yamete-api.herokuapp.com/buscar/$search";
  //   try {
  //     Dio dio = new Dio();
  //     Response response = await dio.get(endPoint);
  //     if(response.statusCode != 200){
  //         Flushbar(
  //         icon: Icon(Icons.error_outline_outlined),
  //         title: 'API não respondeu',
  //         message: 'Por favor tente novamente em alguns minutos',
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 2),
  //       )..show(context);
  //       return null;
  //     }
  //     return DataAllMangas.fromJsonSearch(response.data);
  //   } catch (e) {
  //     Flushbar(
  //       icon: Icon(Icons.error_outline_outlined),
  //       title: 'Erro não tratado',
  //       message: 'Code: ${e}',
  //       backgroundColor: Colors.red,
  //       duration: Duration(seconds: 2),
  //     )..show(context);
  //     return null;
  //   }
  // }

  // ignore: unused_element
  Future<void> _showMyDialog() async {
     return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('chamar novamente ?'),
          content: Text("Foi detectado que a API foi chamada recentemente, escolha sabiamente!"),
          actions: <Widget>[
            FlatButton(
              textColor: Color(0xFF6200EE),
              onPressed: ()async{
                await _handlerGetAllMangas();
              },
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

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<File> _saveData() async {
    String data = json.encode(_favorites);
    final file = await _getFile();
    Flushbar(
      title: 'Favoritos',
      icon: Icon(Icons.favorite),
      message: 'Salvo com sucesso em favoritos',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 4),
    )..show(context);
    return file.writeAsString(data);
  }

  Future<File> _saveDataRemoving(String title) async {
    String data = json.encode(_favorites);
    final file = await _getFile();
    Flushbar(
      title: 'Favorito $title removido',
      icon: Icon(Icons.remove),
      message: 'Removido com sucesso',
      backgroundColor: Colors.red,
      duration: Duration(seconds: 4),
    )..show(context);
    return file.writeAsString(data);
  }

}