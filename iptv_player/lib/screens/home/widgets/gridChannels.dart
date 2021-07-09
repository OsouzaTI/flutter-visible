import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv_player/core/app_colors.dart';
import 'package:iptv_player/core/app_text_styles.dart';
import 'package:transparent_image/transparent_image.dart';

class GridChannels extends StatefulWidget {
  List<dynamic> channels;
  GridChannels({Key key, this.channels}) : super(key: key);

  @override
  _GridChannelsState createState() => _GridChannelsState();
}

class _GridChannelsState extends State<GridChannels> with TickerProviderStateMixin {
  
  List<FocusNode> _focusChannels = [];
  List<AnimationController> _controllerIn = [];
  int selectedIndex = -1;
  bool firstChannelFocus = false;
  @override
  void initState() { 

    for(int i = 0; i < widget.channels.length; i++){

      AnimationController _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 125),
        value: 0.9,
        lowerBound: 0.9,
        upperBound: 1.0
      );
      _controllerIn.add(_controller);


      FocusNode fn = FocusNode(        
        onKey:  (node, event) {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data;
            print("keyCode: ${rawKeyEventDataAndroid.keyCode}");
            switch (rawKeyEventDataAndroid.keyCode) {
              case 66:
                print(widget.channels[i]['link']);
                break;
              case 23:{
                print(widget.channels[i]['link']);
                _openLinkInMxPlayer(widget.channels[i]['link']);
              }break;
              default:
                break;
            }
          }
          return false;
        }
      );
      fn.addListener(() {
        if(fn.hasFocus){
          _controllerIn[i].forward();
          setState(() {
            selectedIndex = i;
          });
          print("Card selecionado: $i");
        }else{
          _controllerIn[i].reverse();
        }
      });
      _focusChannels.add(fn);
    }
    super.initState();    
  }

  void cbKeyBoardListenerOnKey(
    RawKeyEvent event,
    Function keyUp,
    Function keyDown,
    Function keyLeft,
    Function keyRight,
    Function keyCenter
  ){
    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      RawKeyDownEvent rawKeyDownEvent = event;
      RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data;
      print("keyCode: ${rawKeyEventDataAndroid.keyCode}");
      switch (rawKeyEventDataAndroid.keyCode) {
        case 19: //KEY_UP
          keyUp();
          break;
        case 20: //KEY_DOWN
          keyDown();
          break;
        case 21: //KEY_LEFT
          keyLeft();
          break;
        case 22: //KEY_RIGHT
          keyRight();
          break;
        case 23: //KEY_CENTER
          keyCenter();
          break;
        case 66: //KEY_CENTER
          keyCenter();
          break;
        default:
          break;
      }
      setState(() {});
    }
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

  Widget itemBuilder(context, i){
    if(!firstChannelFocus){
      FocusScope.of(context).requestFocus(_focusChannels[0]);
      firstChannelFocus = true;
    }
    
    return RawKeyboardListener(
      focusNode: _focusChannels[i],            
      child: Container(
        color: _focusChannels[i].hasFocus
          ? AppColors.focusTile
          : AppColors.nonFocusTile,
        child: ListTile(          
          leading: Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Color(0x60000000),
              borderRadius: BorderRadius.circular(3.0)
            ),
            child: FadeInImage.memoryNetwork(
              imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/image-404.png'),
              placeholderErrorBuilder: (context, error, stackTrace) => Image.asset('assets/image-404.png'),
              placeholder: kTransparentImage,            
              image: widget.channels[i]['logo'],                        
            ),
          ),
          title: Text(widget.channels[i]['title'], style: AppTextStyles.bodyBold,),
        ),
      ),
      onKey: (event) => cbKeyBoardListenerOnKey(
        event,
        (){},
        (){},
        (){},
        (){},
        (){}
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSideMenu,
      body: Center(
        child: ListView.builder(
          itemCount: widget.channels.length,
          itemBuilder: itemBuilder
        ),
      ),
    );
  }
}

// GridView.builder(          
//   gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 6,
//     crossAxisSpacing: 10,   
//     mainAxisSpacing: 10,    
//     childAspectRatio: 0.9,             
//   ),
//   padding: const EdgeInsets.fromLTRB(
//     10.0, 10, 10.0, 10
//   ),
//   itemBuilder: itemBuilder
// ),