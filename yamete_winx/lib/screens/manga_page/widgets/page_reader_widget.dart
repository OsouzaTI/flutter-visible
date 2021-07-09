import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yamete_winx/main.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:provider/provider.dart';

class PageReader extends StatefulWidget {
  final pageUrl;
  PageReader({Key key, this.pageUrl}) : super(key: key);

  @override
  _PageReaderState createState() => _PageReaderState();
}

class _PageReaderState extends State<PageReader> {
  PhotoViewControllerBase controller;
  PhotoViewScaleStateController scaleStateController;
  double _iniScale;
  double _scale;
  MainModel mainModel;

  @override
  void initState() {    
    super.initState();
    
    controller = PhotoViewController()          
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()      
      ..outputScaleStateStream.listen(onScaleState);
    
  }

  @override
  void didChangeDependencies() {    
    super.didChangeDependencies();
    mainModel = Provider.of<MainModel>(context);
    _iniScale = mainModel.isManhwa ? 5.0  : 1.0;
    _scale    = mainModel.isManhwa ? 10.0 : 1.5;

  }

  @override
  void dispose() { 
    controller.dispose();
    super.dispose();
  }

  void onController(PhotoViewControllerValue value) {
    setState(() {
      print("Mudança de estado");
    });
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print(scaleState);
  }

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: NetworkImage(widget.pageUrl),  
      controller: controller,      
      scaleStateController: scaleStateController,              
      enableRotation: false,   
      initialScale: PhotoViewComputedScale.contained * _iniScale,
      minScale: PhotoViewComputedScale.contained * (_iniScale-1.0),
      maxScale: PhotoViewComputedScale.contained * _scale,   
      basePosition: Alignment.center,  
    );
  }
}