import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoScreen extends StatelessWidget {

  final String url;
  PhotoScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: url,
      ), 
    );
  }
}