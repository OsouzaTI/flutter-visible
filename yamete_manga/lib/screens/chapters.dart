import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:yamete_manga/data/D_Manga.dart';
import 'package:yamete_manga/screens/read.dart';

class ChaptersList extends StatefulWidget {
  ChaptersList({Key key, this.idManga, this.nameManga}) : super(key: key);
  final String idManga;
  final String nameManga;
  @override
  _ChaptersListState createState() => _ChaptersListState();
}

class _ChaptersListState extends State<ChaptersList> {
  ChaptersLinks _links;
  bool _isLoading = false;
  final int maxSizeTitle = 20;
  @override
  void initState() {    
    super.initState();
    _handlerGetAllChaptersLinks();
  }

  _handlerGetAllChaptersLinks() async {
    _handlerToggleIsLoading();
    _links = await _getAllChapters(widget.idManga);
    if(_links != null){
      _handlerToggleIsLoading();
    }
  }

  _handlerToggleIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  String _getTitle(){
    if(widget.nameManga.length > maxSizeTitle)
      return widget.nameManga.substring(0, maxSizeTitle)+"...";
    else return widget.nameManga;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nameManga),),
      body: Container(
        color: const Color(0xFF18343B),
        child: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : GridView.builder(
            itemCount: _links.links.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 5,
              crossAxisCount: 1,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index){    
              // Decrescente         
              //String l = _links.links[_links.links.length - (index+1)];
              // Crescente
              //String l = _links.links[index];
              print(index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(    
                    color: const Color(0xFF001014),                            
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      )
                    ),        
                  ),    
                  padding: EdgeInsets.only(left:10.0, right: 10.0),                
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_getTitle()} ${_links.links.length - (index+1)}", style:
                        TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.read_more, size: 30, color: Colors.white,),
                        onPressed: (){
                          String url = _links.links[index];
                          print(url);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>ReadManga(idManga: url, nameManga: widget.nameManga,))
                          );
                        }
                      )
                    ],
                  ),
                ),
              );
            }
          ),
      ),
    );
  }

  Future<ChaptersLinks> _getAllChapters(String idManga) async {    
    final endPoint = "https://yamete-manga.herokuapp.com/capitulos/$idManga";
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
      return ChaptersLinks.fromJson(response.data);
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

}