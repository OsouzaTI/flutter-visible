import 'package:flutter/material.dart';
import 'package:yamete_anime/api/anime_api.dart';
import 'package:yamete_anime/core/AppTextStyles.dart';
import 'package:yamete_anime/mobx/main_model.dart';
import 'package:provider/provider.dart';
import 'card_anime.dart';

class HomeAnimeGrid extends StatefulWidget {
  HomeAnimeGrid({Key key}) : super(key: key);

  @override
  _HomeAnimeGridState createState() => _HomeAnimeGridState();
}

class _HomeAnimeGridState extends State<HomeAnimeGrid> {

  bool isLoading = false;
  bool categoryLocked = false;
  bool error = false;
  Map<String, Function> _controllerFunctions = Map();
  Animes animes;
  MainModel mainModel;

  @override
  void initState() {
    
    _handlerGetAllAnimes();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    
    mainModel = Provider.of<MainModel>(context);   

    _controllerFunctions['sem categoria'] = _handlerGetAllAnimes;
    _controllerFunctions['categoria'] = _handlerGetAllAnimesByCategory; 
    _controllerFunctions['buscar'] = _handlerSearchAnimes; 
   
    mainModel.setHandlerAnimeFunctions (_controllerFunctions);

    super.didChangeDependencies();    
  }

  _handlerIsLoading(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  _handlerGetAllAnimes() async {
    _handlerIsLoading();
    animes = await AnimeAPI.listarAnimes();
    _handlerIsLoading();
    if(animes == null){
      error = true;   
    }else{
      error = false;   
    }
    categoryLocked = false;
    setState(() {});
  }

  _handlerGetAllAnimesByCategory(String animeCategory) async {
    print(animeCategory);
    _handlerIsLoading();    
    animes = await AnimeAPI.listarCategoriaAnimes(animeCategory);
    _handlerIsLoading();
    if(animes == null){
      error = true;   
    }else{
      error = false;   
    }
    categoryLocked = true;
    setState(() {});
  }

  _handlerSearchAnimes(String animeID) async {
    print(animeID);
    _handlerIsLoading();    
    animes = await AnimeAPI.buscarAnimes(animeID);
    _handlerIsLoading();
    if(animes == null){
      error = true;
    }else{
      error = false;
    } 
    categoryLocked = true;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading 
      ? Center(child: CircularProgressIndicator(),)
      : !error 
        ? GridView.builder(
          itemCount: animes.animes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 5,
          ),
          itemBuilder: (context, i)=>CardAnime(anime: animes.animes[i],categoryLocked: categoryLocked,)
        )  
        : Center(child: Text("Ocorreu um problema :(", style: AppTextStyles.font20,),)   
    );
  }
}