import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yamete_anime/core/AppColors.dart';
import 'package:yamete_anime/core/AppTextStyles.dart';
import 'package:yamete_anime/screens/home/widgets/list_anime_episodes.dart';
import '../../../api/anime_api.dart';
import 'package:yamete_anime/screens/video/webview.dart';

class CardAnime extends StatefulWidget {
  Anime anime;
  bool categoryLocked;
  CardAnime({Key key, this.anime, this.categoryLocked}) : super(key: key);

  @override
  _CardAnimeState createState() => _CardAnimeState();
}

class _CardAnimeState extends State<CardAnime> {
  bool mediaLoading = false;

  _togglerMediaLoading(){
    setState(() {
      mediaLoading = !mediaLoading;
    });
  }

  _handlerSetCategoryAnime() async {
    _togglerMediaLoading();
    String media = await AnimeAPI.mediaAnime(widget.anime.link);
    print(media);
    if(media != null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>VideoPlayerWebView(media: media,))
      );
    }
    _togglerMediaLoading();
  }

  _handlerShowAllEpisodes(String animeID){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>AnimeListEpisodes(animeID: animeID,))
    );
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = 6/9;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      color: Color(0xFF2F2F35),
      child: Stack(
        alignment: Alignment.topCenter,  
        children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image:  widget.anime.img,
            width: 250,                                     
            height: height * aspectRatio,                                     
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: -1,
            left: 0,
            child: Container(
              color: AppColors.appBarColor,
              height: 90,
              width: MediaQuery.of(context).size.width,              
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                overflow: TextOverflow.ellipsis,                  
                text: TextSpan(
                  text: widget.anime.title,
                  style: AppTextStyles.chapterTileText
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,                      
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  onPressed: (){
                    if(!widget.categoryLocked){
                      _handlerSetCategoryAnime();
                    }else{
                      _handlerShowAllEpisodes(widget.anime.link);
                    }
                  },
                  child: mediaLoading 
                    ? CircularProgressIndicator()
                    :  Text(widget.categoryLocked 
                      ? 'Temporadas' : 'Assistir', style: AppTextStyles.buttonPlay,),
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}