import 'package:flutter/material.dart';
import 'package:iptv_player/core/app_colors.dart';
import 'package:iptv_player/core/app_text_styles.dart';
import 'package:transparent_image/transparent_image.dart';

class ChannelTile extends StatelessWidget {
  Function callback;
  dynamic channel;
  FocusNode fn;
  ChannelTile({Key key, this.channel, this.callback, this.fn}) : super(key: key);
    
  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: fn.hasFocus 
        ? AppColors.focusTile
        : AppColors.nonFocusTile,
      child: ListTile(
        focusNode: fn,
        focusColor: Colors.lightBlue[100],
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          width: 60,
          height: 60,
          child: FadeInImage.memoryNetwork(
            imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/image-404.png'),
            placeholderErrorBuilder: (context, error, stackTrace) => Image.asset('assets/image-404.png'),
            placeholder: kTransparentImage,            
            image: channel['logo'],                        
          )       
        ),
        title: Text(channel['title'], style: AppTextStyles.body11),
        onLongPress: () => callback(channel['link']),
      ),
    );
  }
}