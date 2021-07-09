import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yamete_manga/screens/chapters.dart';

class CMangaCard extends StatelessWidget {  
  final String _title;
  final String _img;
  final String _link;
  final bool _isFavorite;
  final Function _saveFavorite;
  final int maxSizeTitle = 30;
  CMangaCard(this._title, this._img, this._link, this._isFavorite, this._saveFavorite);

  String _getTitle(){
    if(_title.length > maxSizeTitle) return _title.substring(0, maxSizeTitle)+"...";
    else return _title;
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = 120;
    double imageHeight = 150;
    return Card(   
      elevation: 5,     
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      color: const Color(0xFF001014),         
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,          
        children: [
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FadeInImage.memoryNetwork(
                imageErrorBuilder: imageBuilderNetworkError,
                placeholderErrorBuilder: imageBuilderNetworkError,
                placeholder: kTransparentImage,
                image: _img,            
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              _getTitle(),
              textAlign: TextAlign.center,
              style: TextStyle(                
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ),
          Container(
            color: const Color(0xFF041B24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(            
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      'Ler',
                      style: TextStyle(
                        color: Colors.blue,
                      )
                    ,),
                    onPressed: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>ChaptersList(idManga: _link, nameManga: _title,)
                        )
                      );                  
                      
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      !_isFavorite ? Icons.favorite_outline : Icons.favorite,
                      size: 25,
                      color: Colors.redAccent,
                    ),
                    onPressed: ()=>_saveFavorite(_title, _img, _link),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget imageBuilderNetworkError(BuildContext context, Object obj, StackTrace error){                
    return Image.asset('images/4041.jpeg');
  }

  // ignore: unused_element
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  

  // Future<String> _readData() async {
  //   try {
  //     final file = await _getFile();
  //     return file.readAsString();
  //   } catch (e) {
  //     return null;
  //   }
  // }

}