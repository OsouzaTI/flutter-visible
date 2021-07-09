import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/main.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:provider/provider.dart';
import 'package:yamete_winx/shared/snackbar_bottom.dart';

class TextFieldSearchWidget extends StatefulWidget {
  TextFieldSearchWidget({Key key}) : super(key: key);

  @override
  _TextFieldSearchWidgetState createState() => _TextFieldSearchWidgetState();
}

class _TextFieldSearchWidgetState extends State<TextFieldSearchWidget> {
  bool _isSearch = false;
  TextEditingController _controller = new TextEditingController();
  FocusNode _focus = new FocusNode();
  MainModel mainModel;

  @override
  void didChangeDependencies() {
    mainModel = Provider.of<MainModel>(context);
    super.didChangeDependencies();    
  }

  _handlerTogglerIsSearch(){
    setState(() {
      _isSearch = !_isSearch;
      if(_isSearch)
        _focus.requestFocus();
    });
  }

  _handlerSubmitSearch(String search){
    switch(mainModel.currentApi){

      case "Manga Yabu":{
        _controller.clear();
        _handlerTogglerIsSearch();
        mainModel.handlerSearch[mainModel.currentApi](search.replaceAll(' ', '+'));
      }break;
      default:{
        showOverlayNotification((_){
          return SnackBarWidget(
            color: Colors.red,
            title: "Função não existe",
            message: "Essa API não possui método de busca",
          );
        }, position: NotificationPosition.bottom);
      }break;

    }
    




  }

  Widget textFieldSearch(){
    return Container(   
        margin: const EdgeInsets.only(bottom: 2),     
        padding: const EdgeInsets.symmetric(vertical: 20),         
        child: Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: 200,
                height: 40,                
                child: TextField(          
                  controller: _controller,
                  textInputAction: TextInputAction.done,                                      
                  onSubmitted: _handlerSubmitSearch,    
                  focusNode: _focus,                  
                  style: TextStyle(
                    color: Colors.white,     
                    fontSize: 20                   
                  ),  
                  cursorColor: AppColors.iconColor,           
                  decoration: InputDecoration(                
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    focusedBorder: UnderlineInputBorder(  
                      borderSide: BorderSide(color: AppColors.iconColor, width: 1)
                    ),
                  ),
                ),                
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.green[600],),        
                onPressed:  _handlerTogglerIsSearch,
              ),
            ],
          ),
        ),          
      );
  }

  Widget buttonSearch(){
    return IconButton(
      icon: Icon(Icons.search, color: AppColors.iconColor,),
      onPressed: _handlerTogglerIsSearch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: !_isSearch
        ? CrossFadeState.showFirst
        : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 150),                        
      firstChild: buttonSearch(),
      secondChild: textFieldSearch(),
    );
    
    
    
  }
}

