import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this.sendMessage);

  final Function({String text, File image}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  
  TextEditingController _controller = new TextEditingController();
  bool _isCompose = false;
  final FocusNode _focusNode = FocusNode();

  final ImagePicker _imagePicker = new ImagePicker();
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.grey[850],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: _showSelectionOriginPhoto
          ),
          Expanded(
            child: Stack(
                alignment: Alignment.centerRight,
                children: [                
                  TextField(
                  controller: _controller,
                  autofocus: false,
                  focusNode: _focusNode,
                  decoration: InputDecoration.collapsed(
                    hintText: "Escrever...",                
                  ),
                  onChanged: (value){
                    //TODO: mensagem sendo escrita
                    setState(() {
                      _isCompose = value.isNotEmpty;
                    });
                  },
                  onSubmitted: (value){
                    widget.sendMessage(text: value);
                    _clearTextAndFalseCompose();
                  },
                ),
                _isCompose ?
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){                    
                    setState(() {
                      _isCompose = false;
                    });                   
                    _controller.clear(); 
                    _focusNode.unfocus();
                    FocusScope.of(context).unfocus();
                  }
                ) : Container()
              ]
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isCompose ? (){
              widget.sendMessage(text: _controller.text);
              _clearTextAndFalseCompose();
            } : null
          )
        ],
      ),
    );
  }

  void _clearTextAndFalseCompose(){
    _controller.clear();
    setState(() {
      _isCompose = false;
    });
  }

  void _getCameraPhoto() async {
    final PickedFile _file = await _imagePicker.getImage(source: ImageSource.camera);
    if(_file != null){
      _imageFile = File(_file.path);
      widget.sendMessage(image: _imageFile);
    }
  }

  void _getGaleryPhoto() async {
    final PickedFile _file = await _imagePicker.getImage(source: ImageSource.gallery);
    if(_file != null){
      _imageFile = File(_file.path);
      widget.sendMessage(image: _imageFile);
    }
  }

  void _showSelectionOriginPhoto(){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              height: 100,
              padding: EdgeInsets.all(10.0),
              child: Row(   
                mainAxisAlignment: MainAxisAlignment.center,                              
                children: [
                  FlatButton(
                    onPressed: (){
                      _getCameraPhoto();
                      Navigator.pop(context);
                    },
                    child: Text("Câmera", style: _bottomSheet(),)
                  ),
                  FlatButton(
                    onPressed: (){
                      _getGaleryPhoto();
                      Navigator.pop(context);
                    },
                    child: Text("Galeria", style: _bottomSheet(),)
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  // Styles
  TextStyle _bottomSheet(){
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

}