import 'package:flutter/material.dart';
import 'package:yamete_anime/core/AppColors.dart';
import 'package:yamete_anime/core/AppTextStyles.dart';
import 'package:yamete_anime/mobx/main_model.dart';
import 'package:provider/provider.dart';

class SearchAnime extends StatefulWidget {
  SearchAnime({Key key}) : super(key: key);

  @override
  _SearchAnimeState createState() => _SearchAnimeState();
}

class _SearchAnimeState extends State<SearchAnime> {
  TextEditingController _controller = TextEditingController();
  MainModel mainModel;

  @override
  void didChangeDependencies() {
    
    mainModel = Provider.of<MainModel>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 150,
      padding: const EdgeInsets.all(5),            
      child: Stack(
        children: [

          TextFormField(
            controller: _controller,
            style: AppTextStyles.font20,
            cursorColor: Colors.white,        
            cursorHeight: 30,  
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.bgColor2)
              )
            ),
            onFieldSubmitted: (String animeID){
              if(animeID.isNotEmpty)
                mainModel.handlerAnimeFunctions['buscar'](animeID);
              else
                mainModel.handlerAnimeFunctions['sem categoria']();
              _controller.clear();          
            },
          ),
          Positioned(
            bottom: 10,
            right: 0,
            child: Icon(Icons.search, size: 20, color: Colors.white,),
          )

        ]
      )
    );
  }
}