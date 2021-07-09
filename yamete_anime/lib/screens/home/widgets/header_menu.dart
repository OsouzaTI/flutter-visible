import 'package:flutter/material.dart';
import 'package:yamete_anime/api/anime_api.dart';
import 'package:yamete_anime/core/AppColors.dart';
import 'package:yamete_anime/core/AppTextStyles.dart';
import 'package:yamete_anime/mobx/main_model.dart';
import 'package:provider/provider.dart';

class HeaderMenu extends StatefulWidget {
  HeaderMenu({Key key}) : super(key: key);

  @override
  _HeaderMenuState createState() => _HeaderMenuState();
}

class _HeaderMenuState extends State<HeaderMenu> {
  bool isLoading = true;
  Categorias categorias;
  MainModel mainModel;

  @override
  void initState() {
    AnimeAPI.categoriasAnimes().then((value){
      setState(() {
        isLoading = false;
        categorias = value;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    
    mainModel = Provider.of<MainModel>(context);
    
    super.didChangeDependencies();    
  }

  Widget _menuButton(Categoria categoria){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20)
          ),
          backgroundColor: MaterialStateProperty.all(AppColors.bgColor),
        ),
        onPressed: () async {
          // usando a categoria
          mainModel.handlerAnimeFunctions['categoria'](categoria.link);
        },
        child: Text(
          categoria.title,
          style: AppTextStyles.menuItem,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLoading ? 5 : 50,
      child: isLoading 
        ? LinearProgressIndicator()
        : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categorias.categorias.length,
          itemBuilder: (context, i)=>_menuButton(categorias.categorias[i])
        ),
    );
  }
}