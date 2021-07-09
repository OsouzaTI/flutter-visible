import 'package:flutter/material.dart';
import 'package:yamete_winx/api/mangas_api.dart';
import 'package:yamete_winx/api/yabu_api.dart';
import 'package:yamete_winx/components/appbar/app_bar_widget.dart';
import 'package:yamete_winx/components/manga_list/manga_list_widget.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:yamete_winx/models/manga_model.dart';
import 'package:yamete_winx/screens/home_screen/widgets/sidebar_widget.dart';
import 'package:provider/provider.dart';
import 'package:yamete_winx/shared/loading_progress_bar.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  MangaModel _mangas;
  bool _isLoading = false;
  bool _safeMode = false;
  Map<String, Function> _handlerDropDownFunctions = Map();
  Map<String, Function> _handlerSearchFunctions   = Map();  
  MainModel mainModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mainModel = Provider.of<MainModel>(context);
    // Setando as funções executadas pelo dropdown
    _handlerSetAllDropDownFunctions();
    _handlerSetSearchFunctions();
  }
  
  @override
  void initState() {    
    //WindowsConfigs.windowsConfig();
    _handlerGetAllChaptersYabuApi();
    super.initState();
  }


  _handlerToggleIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _handlerToggleSafeMode(){
    print("Opa safado");
    setState(() {
      _safeMode = !_safeMode;
    });
  }

  _handlerGetAllChaptersLinks() async {
    _handlerToggleIsLoading();
    _mangas = await MangaAPI.getAllChapters(1);
    if(_mangas != null){      
      _handlerToggleIsLoading();
    }else{

    }
  }

  _handlerGetMangaSearch(String idManga) async {
    _handlerToggleIsLoading();
    _mangas = await YabuAPI.getMangaSearch(idManga);
    if(_mangas != null){      
      _handlerToggleIsLoading();
      print(_mangas);
    }else{

    }
  }


  _handlerGetAllChaptersYabuApi() async {
    _handlerToggleIsLoading();
    _mangas = await YabuAPI.getAllChapters();
    mainModel.setCurrentApi("Manga Yabu");
    if(_mangas != null){      
      _handlerToggleIsLoading();
    }else{

    }
  }

  _handlerSetAllDropDownFunctions(){
    _handlerDropDownFunctions["Manga Yabu"] = _handlerGetAllChaptersYabuApi;  
    _handlerDropDownFunctions["Super Hentais"] = _handlerGetAllChaptersLinks;  
    mainModel.setHandlerDropDown(_handlerDropDownFunctions);
    mainModel.setIsManhua(false);
    mainModel.setScrollAnimation(false);
  }

  _handlerSetSearchFunctions(){
    _handlerSearchFunctions["Manga Yabu"] = _handlerGetMangaSearch;
    mainModel.setHandlerSearch(_handlerSearchFunctions);
  }

  Widget mangaGrid(){
    return _isLoading
      ? LoadingCircularProgressBarWidget()
      : MangaList(model: _mangas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        height: 200,
        safeMode: _safeMode,
        safeModeFunc: _handlerToggleSafeMode,        
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.bgColor
          // gradient: AppGradients.linear03
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: _safeMode 
                ? Container(color: Color(0xff040204), child: Center(child: Image.asset("assets/images/safe_screen01.gif")))
                : mangaGrid(),
            ),
            SideBarWidget()   
          ],
        ),
      ),
    );
  }
}