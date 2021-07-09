import 'package:flutter/material.dart';
import 'package:focusnode_widgets/focusnode_widgets.dart';
import 'package:iptv_player/core/app_colors.dart';

class ButtonA extends StatefulWidget {
  String text;
  Function callback;
  IconData icon;
  FocusNode fn;
  ButtonA({Key key, this.icon, this.text, this.callback, this.fn}) : super(key: key);

  @override
  _ButtonAState createState() => _ButtonAState();
}

class _ButtonAState extends State<ButtonA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.fn.hasFocus
        ? AppColors.focusGroupTitle
        : Colors.transparent,
      child: ListTile(
        focusNode: widget.fn,
        leading: Icon(widget.icon, color: Colors.white,),
        title: Text(widget.text, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}