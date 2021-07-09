import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool safeMode;
  final Function safeModeFunc;
  SwitchWidget({Key key, this.safeMode, this.safeModeFunc}) : super(key: key);

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {

  @override
  Widget build(BuildContext context) {
    return Switch(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: widget.safeMode,
      onChanged: (value){
        widget.safeModeFunc();
        setState(() { });
      },
      activeColor: Colors.green,
      inactiveTrackColor: Colors.grey,
    );
  }
}