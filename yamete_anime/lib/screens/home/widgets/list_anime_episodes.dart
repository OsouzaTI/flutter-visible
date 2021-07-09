import 'package:flutter/material.dart';
import 'package:yamete_anime/api/anime_api.dart';
import 'package:yamete_anime/core/AppColors.dart';
import 'package:yamete_anime/core/AppTextStyles.dart';
import 'package:yamete_anime/screens/video/webview.dart';

class AnimeListEpisodes extends StatefulWidget {
  String animeID;
  AnimeListEpisodes({Key key, this.animeID}) : super(key: key);

  @override
  _AnimeListEpisodesState createState() => _AnimeListEpisodesState();
}

class _AnimeListEpisodesState extends State<AnimeListEpisodes> {

  bool isLoading = false;
  Temporadas temporadas;

  @override
  void initState() {
    _handlerGetAllAnimeEpisodes();
    super.initState();
  }

  _handlerSetIsLoading(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  _handlerGetAllAnimeEpisodes() async {
    _handlerSetIsLoading();
    print(widget.animeID);
    temporadas = await AnimeAPI.animeTemporadas(widget.animeID);
    // print(temporadas);
    if(temporadas != null){
      _handlerSetIsLoading();
    }
  }

  _handlerPlayAnimeEpisode(String animeID) async {    
    String media = await AnimeAPI.mediaAnime(animeID);
    print(media);
    if(media != null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>VideoPlayerWebView(media: media,))
      );
    }
    setState(() {});
  }

  Widget _itemBuilder(context, i){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(temporadas.temporadas[i].title, style: AppTextStyles.font20,),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: temporadas.temporadas[i].animes.animes.length,
              itemBuilder: (context, j) => ListTile(
                title: Text(
                  temporadas.temporadas[i].animes.animes[j].title,
                  style: AppTextStyles.dropdownHint,
                ),
                onTap: (){
                  _handlerPlayAnimeEpisode(temporadas.temporadas[i].animes.animes[j].link);
                },
              )
            ),
          ),
        ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children:[
          isLoading 
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            itemCount: temporadas.temporadas.length,
            itemBuilder: _itemBuilder
          ),
          IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            }
          ),
        ] 
      )
    );
  }
}