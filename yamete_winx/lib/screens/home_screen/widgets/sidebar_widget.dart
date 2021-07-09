import 'package:flutter/material.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppGradients.dart';
import 'package:yamete_winx/screens/home_screen/widgets/textfield_search_widget.dart';

class SideBarWidget extends StatefulWidget {
  SideBarWidget({Key key}) : super(key: key);

  @override
  _SideBarWidgetState createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(            
      width: 60,
      decoration: BoxDecoration(
        gradient: AppGradients.linear02,
        border: Border(
          left: BorderSide(
            color: AppColors.iconColor
          )
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.download_rounded, color: AppColors.iconColor,),
            onPressed: (){}
          ),
          IconButton(
            icon: Icon(Icons.star, color: AppColors.iconColor,),
            onPressed: (){}
          ),                
        ],
      ),
    );
  }
}