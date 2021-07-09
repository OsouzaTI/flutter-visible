import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m3u/m3u.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  try {
    File file = File("${directory.path}/data.json");    
    return file;
  } catch (e) {
    return null;
  }
  
}

Future<File> saveData(list) async {
  String data = json.encode(list);
  final file = await getFile();
  return file.writeAsString(data);
}

Future<String> readData() async {
  try {
    final file = await getFile();
    bool existFile = await file.exists();
    if(existFile)
      return file.readAsString();
  } catch (e) {
    return null;
  }
}

Future<Map<String, List<Map<String, String>>>> parseM3u(
    String filePath,    
  ) async {
    
    Map<String, List<Map<String, String>>> _group = Map();
    final fileContent = await File(filePath).readAsString();
  
      
    final m3u = await M3uParser.parse(fileContent);

    for (final entry in m3u) {
      Map<String, String> _map = new Map();
      _map['title'] = entry.title;
      _map['logo']  = entry.attributes['tvg-logo'];
      _map['link']  = entry.link;        
      _map['category'] = entry.attributes['group-title'];
      // map.add(_map);
      String _category = entry.attributes['group-title']; 
      if(_group.containsKey(_category)){
        List<Map<String, String>> list = _group[_category];
        list.add(_map);
      }else{
        _group[_category] = [];//inicializando
        _group[_category].add(_map);          
      }
    }

  return _group;
}