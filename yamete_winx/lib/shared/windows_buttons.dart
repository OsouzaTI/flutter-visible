import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:yamete_winx/core/AppColors.dart';

class WindowButtomWidget extends StatelessWidget {
  const WindowButtomWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowButtons();
  }
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