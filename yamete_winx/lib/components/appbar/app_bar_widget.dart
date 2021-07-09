import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:yamete_winx/components/appbar/widget/menu_bar/menu_bar.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppGradients.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';
import 'package:yamete_winx/shared/switch_widget.dart';

class AppBarWidget extends PreferredSize {
  final double height;
  final bool safeMode;
  final Function safeModeFunc;
  AppBarWidget({this.height, this.safeMode, this.safeModeFunc}) : super(
    preferredSize: Size.fromHeight(height),
    child: Container(
      height: height,
      // Mesma cor do background
      color: Colors.blue[50], 
      child: Stack(          
        children: [   
          Container(
            height: height,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: AppGradients.linear02,
              color: Colors.black,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.iconColor,
                  width: 5
                )
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center,            
              children: [
                Text.rich(
                  TextSpan(
                    // text: "Bem vindo ao ",
                    style: AppTextStyles.font20,
                    children: [
                      TextSpan(
                        text: "Yamete winX",
                        style: AppTextStyles.yameteLabel
                      )
                    ]
                  )
                ),
              ],
            ),
          ),
          WindowTitleBarBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(                  
                  child: MoveWindow()
                ),
                SizedBox(
                  width: 60,
                  child: SwitchWidget(safeMode: safeMode, safeModeFunc: safeModeFunc)
                ),
                WindowButtons()
              ]
            )
          ),
          Align(
            alignment: Alignment(0.0, 1.0),
            child: MenuBarWidget()
          )
        ],
      ),
    )
  );
}

final buttonColors = WindowButtonColors(
    iconNormal: AppColors.iconColor,
    mouseOver: Color(0xFF24A32F),
    mouseDown: Color(0xFF068047),
    iconMouseOver: Color(0xFF346820),
    iconMouseDown: Color(0xFF49AF21));

final closeButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: AppColors.iconColor,
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}