import 'package:flutter/material.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';

class MangaChapterTileWidget extends StatelessWidget {
  final String title;
  final String link;
  final String data;
  final Function handlerRead;
  const MangaChapterTileWidget({
    Key key,
    this.title,
    this.link,
    this.data,
    this.handlerRead
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.dropdownColor)
        )
      ),
      child: ListTile(
        leading: Icon(Icons.bookmark_border, color: AppColors.iconColor,),
        title: Text(title, style: AppTextStyles.chapterTileText,),
        subtitle: Text(data, style: AppTextStyles.chapterSubTileText,), 
        onTap: ()=>handlerRead(title, link),       
      ),
    );
  }
}