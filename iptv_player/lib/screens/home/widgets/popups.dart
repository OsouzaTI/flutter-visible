import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:focusnode_widgets/focusnode_widgets.dart';
import 'package:iptv_player/data/db.dart';
import 'package:m3u/m3u.dart';

Widget addListPopup(BuildContext context) {
  
  // final _controller = new TextEditingController();
  // FilePickerResult _result;
  Map<String, List<Map<String, String>>> _group = new Map();

  void _filePicker() async {

    FilePickerResult result = await FilePicker.platform.pickFiles();

    if(result != null) {
      print(result.files.single.path);
      _group = await parseM3u(result.files.single.path);
      saveData(_group).then((value) => Navigator.pop(context));
    } else {
      // User canceled the picker
    }

  }

  return new AlertDialog(
    title: const Text('Popup example'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Arquivo por URL - TODO
        // Text("Digite a URL"),
        // TextFormField(
        //   controller: _controller,
        // )
        VerticalMenuForAndroidTV(
          menuItems: [
            FocusableSimpleMenuItem(
              child: Text("Selecione o arquivo"),
              enterTapActionCallback: (context)=>_filePicker(),
              autoFocus: true,
            ),
          ],
          focusedBackgroundDecoration: BoxDecoration(
            border: Border.all(color: Colors.amber[900], width: 2),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxHeight: 40,
            maxWidth: 700,
            minHeight: 10,
            minWidth: 100,
          ),
        )

      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: ()=> Navigator.pop(context), /* Usa a API */
        child: Text("Fechar")
      ),
      TextButton(
        onPressed: ()=>print("usa a api")/* Usa a API */,
        child: Text("Adicionar")
      )
    ],
  );
}
