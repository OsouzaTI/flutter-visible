import 'package:flutter/material.dart';
import 'dart:async';

import 'package:webview_windows/webview_windows.dart';

class VideoPlayerWebView extends StatefulWidget {
  String media;
  VideoPlayerWebView({Key key, this.media}) : super(key: key);

  @override
  _VideoPlayerWebViewState createState() => _VideoPlayerWebViewState();
}

class _VideoPlayerWebViewState extends State<VideoPlayerWebView> {
  WebviewController _controller;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() { 
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    _controller = WebviewController();

    await _controller.initialize();

    await _controller.loadUrl(widget.media);

    if (!mounted) return;

    setState(() {});
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(0),
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  children: [
                    Webview(_controller),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                      onPressed: (){
                        Navigator.pop(context);
                      }
                    ),
                    StreamBuilder<LoadingState>(
                      stream: _controller.loadingState,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data == LoadingState.Loading) {
                          return LinearProgressIndicator();
                        } else {
                          return Container();
                        }
                      }
                    ),
                  ],
                )
              )
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: compositeView(),
      ),
    );
  }
}