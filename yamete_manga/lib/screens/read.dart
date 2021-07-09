import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yamete_manga/data/D_Chapters.dart';

class ReadManga extends StatefulWidget {
  ReadManga({Key key, this.idManga, this.nameManga}) : super(key: key);
  final String idManga;
  final String nameManga;
  
  @override
  _ReadMangaState createState() => _ReadMangaState();
}

const double minScale = 0.4;
const double defScale = 0.5;
const double maxScale = 5.0;

class _ReadMangaState extends State<ReadManga> {
  DChapters chapters;
  bool _isLoading = false;
  bool _hasChangedZoom = false;
  int page = 0;
  int calls = 0;
  bool _isManhua = false;
  PhotoViewControllerBase controller;
  PhotoViewScaleStateController scaleStateController;

  double _iniScale = 1.0;
  double _scale = 2.5;

  @override
  void initState() {    
    super.initState();
    _handlerGetAllChapterPages();
    controller = PhotoViewController()
      // ..scale = defScale
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()      
      ..outputScaleStateStream.listen(onScaleState);

    

  }

  @override
  void dispose() {
    controller.dispose();
    scaleStateController.dispose();
    super.dispose();
  }

  void onController(PhotoViewControllerValue value) {
    setState(() {
      calls += 1;
    });
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print(scaleState);
  }

  _handlerGetAllChapterPages() async {
    _handlerTogglerIsLoading();
    chapters = await _getAllChapterPages();
    if(chapters.links.isNotEmpty && chapters != null){
      _handlerTogglerIsLoading();
    }
  }

  _handlerTogglerIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _handlerNextPage(){
    setState(() {
      if(page < chapters.links.length) page++;
    });
    _handlerResetZoom();
  }

  _handlerPreviousPage(){
    setState(() {
      if(page > 0) page--;
    });
    _handlerResetZoom();
  }

  _handlerResetZoom(){
      if(_hasChangedZoom){
        controller.reset();
        _hasChangedZoom = false;
      } 
  }

  _handlerTogglerIsManhua(bool value){
    setState(() {
      _isManhua = value;
      _iniScale = _isManhua ? 8.0 : 1.0;
      _scale = _isManhua ? 10.0 : 2.5;      
    });
    // new initial scale
    controller = PhotoViewController()
    ..scale = _iniScale
    ..outputStateStream.listen(onController);
    
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameManga),        
        actions: [
          Column(
            children: [
              Switch(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: _isManhua,
                onChanged: (value)=>_handlerTogglerIsManhua(value),
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey,
              ),
              Text("Manhua", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white),)
            ],
          ),
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: _handlerPreviousPage,
          ),
          Center(
            child: Text(
              page.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),               
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: _handlerNextPage,
          ),
        ],
      ),      
      body: Container(
        child: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : pageContainer(page),
      ),
    );
  }

  Widget pageContainer(int index){
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.all(5),          
      alignment: Alignment.center,                      
      child: PhotoView(
        imageProvider: NetworkImage(chapters.links[index]),
        controller: controller,
        scaleStateController: scaleStateController,
        enableRotation: false,               
        initialScale: PhotoViewComputedScale.contained  * _iniScale,
        minScale: PhotoViewComputedScale.contained      * (_iniScale-1.0),
        maxScale: PhotoViewComputedScale.covered        * _scale,      
        basePosition: Alignment.center,  
        backgroundDecoration: BoxDecoration(
          color: Colors.white
        ),
      )
    ); 
  }

  Future<DChapters> _getAllChapterPages() async {
    final endPoint = "https://yamete-manga.herokuapp.com/ler/${widget.idManga}";    
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
      return DChapters.fromJson(response.data);
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