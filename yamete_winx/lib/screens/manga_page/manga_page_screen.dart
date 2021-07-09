import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yamete_winx/api/mangas_api.dart';
import 'package:yamete_winx/api/yabu_api.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppGradients.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:yamete_winx/models/page_models.dart';
import 'package:yamete_winx/screens/manga_page/widgets/page_reader_widget.dart';
import 'package:yamete_winx/shared/loading_progress_bar.dart';
import 'package:yamete_winx/shared/snackbar_bottom.dart';
import 'package:yamete_winx/shared/switch_widget.dart';
import 'package:yamete_winx/shared/windows_buttons.dart';
import 'package:provider/provider.dart';

class MangaPageScreen extends StatefulWidget {
  final String name;
  final String link;  
  MangaPageScreen({Key key, this.name, this.link}) : super(key: key);
  @override
  _MangaPageScreenState createState() => _MangaPageScreenState();
}

class _MangaPageScreenState extends State<MangaPageScreen> {
  PageModel _pages;
  bool _isLoading = false;
  ScrollController _scrollController;
  int page = 0;
  bool _safeMode = false;
  bool _scrollAnimation = false;
  MainModel mainModel;
  double _speedPage = 0.0;

  @override
  void initState() { 
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControllerFunc); 
  }
  
  // Detecta a API que está ativa
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mainModel = Provider.of<MainModel>(context);
    switch (mainModel.currentApi) {
      case "Mangas Hentai":
        _handlerGetAllPages();        
        break;
      case "Manga Yabu":
        _handlerGetAllPagesYabuApi();
        break;
      default:
        _handlerGetAllPages(); 
    }    
    autorun((_){

    });
  }

  _handlerToggleIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _handlerGetAllPages() async {
    _handlerToggleIsLoading();
    _pages = await MangaAPI.getAllPages(widget.link);
    if(_pages != null){      
      _handlerToggleIsLoading();
    }else{
      print("Retornou nulo");
    }
  }

  _handlerGetAllPagesYabuApi() async {
    _handlerToggleIsLoading();
    _pages = await YabuAPI.getAllPages(widget.link);
    if(_pages != null){      
      _handlerToggleIsLoading();
    }else{
      print("Retornou nulo");
    }
  }

  _handlerScrollAnimation(){
    setState(() {
      _scrollAnimation = !_scrollAnimation; 
    });
    //mainModel.setScrollAnimation(_scrollAnimation);
    if(_scrollAnimation)
      _handlerAnimation(_scrollController.offset);

  }

  String getName(){
    return "Page : $page | " + widget.name;
  }

  _scrollControllerFunc(){    
    page = (_scrollController.offset / MediaQuery.of(context).size.width).floor();
    setState(() {});
  }

  _handlerTogglerSafeMode(){
    setState(() {
      _safeMode = !_safeMode;
    });
  }

  _handlerAnimation(double value) async {

    int time = 200;
    try {

      _scrollController.animateTo(
        value,
        duration: Duration(milliseconds: time),
        curve: Curves.fastOutSlowIn,
      );
      
      await Future.delayed(Duration(milliseconds: 100));
      if(_scrollAnimation && value < _scrollController.position.maxScrollExtent)
        _handlerAnimation(value+_speedPage);

    } catch (e) {

      showOverlayNotification((_){
        return SnackBarWidget(
          icon: Icons.info_outline,
          color: AppColors.iconColor,
          title: "Animação desligada",
          message: "A animção não pode continuar",
        );
      }, position: NotificationPosition.bottom);

    }
  }

  _handlerChangeSpeedPage(double speed){
    setState(() {
      _speedPage = speed;
    });
  }

  _handlerPopNavigator(BuildContext context){
    Navigator.pop(context);
  }

  Widget pageContainer(int index){
    return Container(
      child: _safeMode 
        ?Center(
          child: Image.network("https://media.tenor.com/images/459aa48503cbe8141586c5be432b65f6/tenor.gif"),)
        : Container(
          // color: Colors.red,
          child: Image.network(
            _pages.pages[index].url,
            fit: BoxFit.cover,
          ),
        )
    );
  }

  Size get widthInfo => MediaQuery.of(context).size;

  double getWidth(){

    double width = widthInfo.width;

    if(width > 1000)
      return width * 0.6;
    if(width < 900)    
      return width;
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Container(
        decoration: BoxDecoration(          
          gradient: AppGradients.linear02
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              color: Colors.black,            
              child: Row(
                children: [
                  SizedBox(
                    width: 60, 
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.iconColor,),                 
                      onPressed: () => _handlerPopNavigator(context),
                    )
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: MoveWindow(                          
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .50,
                                  child: Text(
                                    getName(),
                                    style: AppTextStyles.chapterTileText,
                                    overflow: TextOverflow.ellipsis,                                
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Slider(
                                        value: _speedPage,
                                        onChanged: _handlerChangeSpeedPage,
                                        min: 0,
                                        max: 10.0,
                                      ),
                                    ),
                                    SwitchWidget(
                                      safeMode: _scrollAnimation,
                                      safeModeFunc: _handlerScrollAnimation,
                                    ),      
                                  ],
                                ),
                                // SwitchWidget(safeMode: _safeMode, safeModeFunc: _handlerTogglerSafeMode,),
                              ],
                            ),
                          )
                        ),
                        WindowButtomWidget(),
                      ],
                    )
                  ),          
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container( 
                width: getWidth(),
                color: AppColors.bgColor,
                child: _isLoading 
                  ? LoadingCircularProgressBarWidget()
                  : ListView.separated(                  
                    scrollDirection: Axis.vertical,
                    itemCount: _pages.pages.length,
                    shrinkWrap: true,
                    controller: _scrollController,                        
                    //physics: PageScrollPhysics(),              
                    itemBuilder: (context, p) => pageContainer(p),
                    separatorBuilder: (context, _) {
                      return SizedBox(height: 10,);
                    },
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ListView.builder(
//   scrollDirection: Axis.horizontal,
//   itemCount: _pages.pages.length,
//   shrinkWrap: true,
//   controller: _scrollController,                        
//   physics: PageScrollPhysics(),              
//   itemBuilder: (context, p) => pageContainer(p)
// ),