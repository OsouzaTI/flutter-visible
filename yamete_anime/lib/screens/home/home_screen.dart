import 'package:flutter/material.dart';
import 'package:yamete_anime/screens/home/widgets/header_menu.dart';
import 'package:yamete_anime/screens/home/widgets/home_grid_anime.dart';
import 'package:yamete_anime/screens/home/widgets/search_text.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: HeaderMenu()),
                SizedBox(width: 20,),
                SearchAnime()
              ],
            ),
            Expanded(child: HomeAnimeGrid()),
          ],
        ),
      ),
    );
  }
}