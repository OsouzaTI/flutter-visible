import 'package:flutter/material.dart';
import 'package:yamete_winx/components/manga_list/widgets/card_manga_widget.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:yamete_winx/models/manga_model.dart';

class MangaList extends StatelessWidget {
  final MangaModel model;  
  const MangaList({Key key, this.model}) : super(key: key);

  int _itemsPerRow(BuildContext context){
    
    double _w = MediaQuery.of(context).size.width;
    if(_w < 1100){
      return 3;
    } else if(_w >= 1100 && _w < 1500){
      return 4;
    } else if(_w >= 1500){
      return 5;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _itemsPerRow(context),
          crossAxisSpacing: 60,   
          mainAxisSpacing: 40,    
          childAspectRatio: 1,             
        ),
        
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: model.mangas.length,
        itemBuilder: (context, i){
          return CardManga(
            title: model.mangas[i].title,
            url:  model.mangas[i].img,
            link: model.mangas[i].link,  
            chapterID: model.mangas[i].chapterID,                 
          );
        }
      ),
    );
  }
}