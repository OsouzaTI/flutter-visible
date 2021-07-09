import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnode_widgets/focusnode_widgets.dart';
import 'package:iptv_player/core/app_colors.dart';
import 'package:iptv_player/core/app_gradients.dart';
import 'package:iptv_player/core/app_text_styles.dart';
import 'package:iptv_player/data/db.dart';
import 'package:iptv_player/mobx/main_model.dart';
import 'package:iptv_player/screens/home/widgets/buttons.dart';
import 'package:iptv_player/screens/home/widgets/gridChannels.dart';
import 'package:iptv_player/screens/home/widgets/group.dart';

import 'package:iptv_player/screens/home/widgets/popups.dart';
import 'package:iptv_player/widgets/CustomExpansionTile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Layout extends StatefulWidget {
  Layout({Key key}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool isLoading = false;
  Map<String, dynamic> _group;
  List<String> _keys = [];
  MainModel model;
  List<FocusNode> _focusGroupChannels = [];
  List<bool> _expandedGroupChannels = [];
  List<GlobalKey> _groupExpansionTileKeys = [];
  bool isFirstIn = true;
  int offsetMenuButtons = 3;

  @override
  void initState() {
    super.initState();
    // cria do 0 ao tamanho do array
    _handlerAddFocusButtons();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    model = Provider.of<MainModel>(context);
    _handlerInitializeMaps();

  }

  _clearMaps(){
    if(_group != null && _keys != null){      
      _keys.clear();
      _focusGroupChannels.clear();
      _groupExpansionTileKeys.clear();
    }
  }
  
  _handlerAddFocusButtons(){
    FocusNode fnMenuBt01 = FocusNode();
    FocusNode fnMenuBt02 = FocusNode();
    FocusNode fnMenuBt03 = FocusNode();
    _focusGroupChannels.add(fnMenuBt01);
    _focusGroupChannels.add(fnMenuBt02);
    _focusGroupChannels.add(fnMenuBt03);
  }

  _handlerInitializeMaps(){

    if(model.getGroupChannels.isNotEmpty){
      _clearMaps();
      _handlerAddFocusButtons();
      setState(() {
        _group = model.getGroupChannels;
        _group.keys.forEach((k){

          // cria do 0 ao tamanho do array
          FocusNode _focus = FocusNode();
          _focusGroupChannels.add(_focus);
          _expandedGroupChannels.add(false);
          _keys.add(k);

          GlobalKey globalKey = GlobalKey();
          print(globalKey.hashCode);
          _groupExpansionTileKeys.add(globalKey);

        });             
      });           
    }
  }

  _handlerInitializeMapsUrl(){
    print(_group.length);
    _clearMaps();
    _handlerAddFocusButtons();
    _group.keys.forEach((k){
      _keys.add(k);
      FocusNode _focus = FocusNode();
      _focusGroupChannels.add(_focus);      
       GlobalKey globalKey = GlobalKey();        
      _groupExpansionTileKeys.add(globalKey);
    });
  }

  void cbKeyBoardListenerOnKey(
    RawKeyEvent event,
    Function keyUp,
    Function keyDown,
    Function keyLeft,
    Function keyRight,
    Function keyCenter
  ){
    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      RawKeyDownEvent rawKeyDownEvent = event;
      RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data;
      print("keyCode: ${rawKeyEventDataAndroid.keyCode}");
      switch (rawKeyEventDataAndroid.keyCode) {
        case 19: //KEY_UP
          keyUp();
          break;
        case 20: //KEY_DOWN
          keyDown();
          break;
        case 21: //KEY_LEFT
          keyLeft();
          break;
        case 22: //KEY_RIGHT
          keyRight();
          break;
        case 23: //KEY_CENTER
          keyCenter();
          break;
        case 66: //KEY_CENTER
          keyCenter();
          break;
        default:
          break;
      }
      setState(() {});
    }
  }
  
  @override
  void dispose() {
    super.dispose();
    for(FocusNode fn in _focusGroupChannels){
      fn.dispose();
    }
  }

  _handlerIsLoading(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  _handlerLoadingListStorage() async {
    _handlerIsLoading();

    String res = await readData();
    _clearMaps();
    final _map = json.decode(res);
    _map.keys.forEach((k)=>_keys.add(k));
    setState(() {
      _group = _map;                                  
    });

    _handlerInitializeMaps();    
    _handlerIsLoading();
  }

  _handlerLoadingListUrl() async {
    _handlerIsLoading();

    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    // // download do raw (playlist de canais)
    await Dio().download(
    'https://raw.githubusercontent.com/OsouzaTI/flutter-projects/master/iptv_player/lib/m3u/lista_url.m3u',
    '${directory.path}/raw_data.m3u');
    
    dynamic res = await parseM3u('${directory.path}/raw_data.m3u');
    print("ta salvo mesmo!");
    setState(() {
      _group = res;
    });
    _handlerInitializeMapsUrl();
    _handlerIsLoading();
  }


  @override
  Widget build(BuildContext context) {    
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: AppColors.backgroundSideMenu,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      RawKeyboardListener(
                        key: PageStorageKey<String>('bt0'),
                        focusNode: _focusGroupChannels[0],                        
                        child: Container(
                          color: _focusGroupChannels[0].hasFocus
                            ? AppColors.focusGroupTitle
                            : Colors.transparent,
                          child: ListTile(                                                    
                            leading: Icon(Icons.add_circle_outline, color: Colors.white,),
                            title: Text('Adicionar Lista', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        onKey: (event) => cbKeyBoardListenerOnKey(
                          event,
                          (){print("up");},
                          (){
                            print("down");
                          },
                          (){
                            print("left");
                            // FocusScope.of(context).requestFocus(_focusGroupChannels[1]);
                          },
                          (){print("right");},
                          (){
                            print("center");
                            showDialog(
                              context: context,
                              builder: (context) => addListPopup(context)
                            );         
                          }
                        ),
                      ),
                      RawKeyboardListener(
                        key: PageStorageKey<String>('bt1'),
                        focusNode: _focusGroupChannels[1],
                        child: Container(
                          color: _focusGroupChannels[1].hasFocus
                            ? AppColors.focusGroupTitle
                            : Colors.transparent,
                          child: ListTile(                                                    
                            leading: Icon(Icons.refresh, color: Colors.white,),
                            title: Text('Carregar', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        onKey: (event) => cbKeyBoardListenerOnKey(
                          event,
                          (){
                            print("up");
                          },
                          (){print("down");},
                          (){
                            print("left");
                            // FocusScope.of(context).requestFocus(_focusGroupChannels[0]);
                          },
                          (){print("right");},
                          (){
                            _handlerLoadingListStorage();                            
                          }
                        ),
                      ),
                      RawKeyboardListener(
                        key: PageStorageKey<String>('bt2'),
                        focusNode: _focusGroupChannels[2],
                        child: Container(
                          color: _focusGroupChannels[2].hasFocus
                            ? AppColors.focusGroupTitle
                            : Colors.transparent,
                          child: ListTile(                                                    
                            leading: Icon(Icons.cloud_done_outlined, color: Colors.white,),
                            title: Text('Carregar de URL', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        onKey: (event) => cbKeyBoardListenerOnKey(
                          event,
                          (){
                            print("up");
                          },
                          (){print("down");},
                          (){
                            print("left");
                            // FocusScope.of(context).requestFocus(_focusGroupChannels[0]);
                          },
                          (){print("right");},
                          (){
                            _handlerLoadingListUrl();
                          }
                        ),
                      ),
                    ],
                  ),
                  Text('versão 0.1', style: AppTextStyles.body11,)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: AppGradients.linear02
              ),              
              child: isLoading
                ? Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),)
                )
                : ListView.builder(                      
                itemCount: _group.length,                      
                itemBuilder: (context, k){
                  int i = k + offsetMenuButtons;
                  return RawKeyboardListener(
                    focusNode: _focusGroupChannels[i],                          
                    child: Container(
                      color: _focusGroupChannels[i].hasFocus
                        ? AppColors.focusGroupTitle 
                        : Colors.transparent,
                      child: ListTile(
                        key: _groupExpansionTileKeys[k],                                                           
                        title: Text(_keys[k], style: AppTextStyles.bodyBold,),                              
                      ),
                    ),
                    onKey: (event) => cbKeyBoardListenerOnKey(
                      event,
                      (){print("up");},
                      (){
                        print("down");
                      },
                      (){print("left");},
                      (){print("right");},
                      (){
                        print("center");     
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>GridChannels(
                            channels: _group[_keys[k]],
                          ))
                        );                               
                      }
                    ),
                  ); 
                }                       
              ),
            ),
          ),
        ],
      ),
    );
  }
}
