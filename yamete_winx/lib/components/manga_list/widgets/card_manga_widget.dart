import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yamete_winx/components/manga_list/widgets/button_widget.dart';
import 'package:yamete_winx/core/AppGradients.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:yamete_winx/screens/manga_chapter_page/manga_chapter_page_widget.dart';
import 'package:yamete_winx/screens/manga_page/manga_page_screen.dart';

class CardManga extends StatefulWidget {
  final String url;
  final String title;
  final String link;  
  final String chapterID;
  CardManga({Key key, this.title, this.url, this.link, this.chapterID}) : super(key: key);

  @override
  _CardMangaState createState() => _CardMangaState();
}

class _CardMangaState extends State<CardManga> {

  _navigationPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaPageScreen(name: widget.title, link: widget.link,)),
    );
  }

  _navigationChapters(){
    // print(widget.chapterID);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaChapterScreen(chapterID: widget.chapterID,)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ClipRRect(        
        // borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: widget.url,                                     
              fit: BoxFit.cover,
            ),
            Container(              
              decoration: BoxDecoration(
                gradient: AppGradients.linearCard,                          
              ),            
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.titleMangaCard,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,                    
                    children: [
                      ButtomWidget(title: "read", onClick: _navigationPage,),
                      ButtomWidget(title: "chapters", onClick: _navigationChapters,),
                      ButtomWidget(title: "shared",),
                      ButtomWidget(title: "favorite",)
                    ],
                  ),
                ),
              ],
            ),     
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container( 
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10)
  //     ),
  //     padding: const EdgeInsets.all(10),
  //     child: Stack(
  //       children: [
  //         Center(
  //           child: ClipRRect(
  //             // borderRadius: BorderRadius.circular(20),
  //             child: FadeInImage.memoryNetwork(
  //               placeholder: kTransparentImage,
  //               image: widget.url,              
  //               width: 250,                
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),               
  //         Column(            
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [       
  //             Container(
  //               child: Text(
  //                 widget.title,
  //                 style: AppTextStyles.titleMangaCard,
  //                 overflow: TextOverflow.ellipsis,
  //                 textAlign: TextAlign.center
  //               ),
  //             ),              
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 ButtomWidget(title: "read", onClick: _navigationPage,),
  //                 SizedBox(width: 20,),
  //                 ButtomWidget(title: "shared",),
  //                 SizedBox(width: 20,),
  //                 ButtomWidget(title: "favorite",)
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // 
}
