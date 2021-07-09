import 'dart:async';

// import 'package:android_intent/android_intent.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnode_widgets/focusnode_widgets.dart';
import 'package:iptv_player/core/app_colors.dart';
import 'package:iptv_player/core/app_text_styles.dart';
import 'package:iptv_player/screens/home/widgets/tile.dart';
import 'package:iptv_player/widgets/CustomExpansionTile.dart';

class GroupChannel extends StatefulWidget {
  String title;
  List<dynamic> group;
  bool expanded;
  Function(GlobalKey) cbAddGlobalKey;
  GlobalKey globalKey;
  GroupChannel({
    Key key,
    this.group,
    this.title,
    this.expanded,
    this.cbAddGlobalKey,
    this.globalKey
  }) : super(key: key);

  @override
  _GroupChannelState createState() => _GroupChannelState();
}

class _GroupChannelState extends State<GroupChannel> {

  List<FocusNode> _focusTile = [];

  @override
  void initState() {    
    super.initState();
    for(int i = 0; i < widget.group.length; i++){
      FocusNode fn = FocusNode(
        onKey: (node, event) {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data;
            print("keyCode: ${rawKeyEventDataAndroid.keyCode}");
            switch (rawKeyEventDataAndroid.keyCode) {
              case 66:
                print(widget.group[i]['link']);
                break;
              case 23:{
                print(widget.group[i]['link']);
                _openLinkInMxPlayer(widget.group[i]['link']);
              }break;
              default:
                break;
            }
          }
          return false;
        },
      );
      _focusTile.add(fn);
    }
  }

  @override
  void dispose() {    
    for(FocusNode fn in _focusTile)
      fn.dispose();
    super.dispose();
  }

  void _openLinkInMxPlayer(String uri) {
    
    final AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      type: "video",
      data: Uri.encodeFull(uri),
      package: 'com.mxtech.videoplayer.ad');
    intent.launch();
    
    // final snackBar = SnackBar(
    //   content: Text('Yay! A SnackBar!'),
    //   action: SnackBarAction(
    //     label: 'Undo',
    //     onPressed: () {
    //       // Some code to undo the change.
    //     },
    //   ),
    // );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.backgroundSideMenu,
            width: 1
          )
        )
      ),
      child: BetterExpansionTile(
        key: widget.globalKey,      
        title: Text(widget.title, style: AppTextStyles.bodyBold, ),      
        children: widget.group.map((e){        
          
        }).toList()
      ),
    );
  }
}

