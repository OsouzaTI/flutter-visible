import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    home: Todo(),
  ));
}

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final todoController = TextEditingController();
  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;

  @override
  void initState(){
    super.initState();
    _readData().then((data){
      setState(() {
        _toDoList = json.decode(data);        
      });
    });
  }

  void _addToDo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = todoController.text;
      todoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);      
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      
      _toDoList.sort((a, b){
        if(a["ok"] && !b["ok"]) return 1;
        if(!a["ok"] && b["ok"]) return -1;
        else return 0;
      });

      _saveData();

    });
    return Null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: "Nova to-do",
                      labelStyle: TextStyle(
                        color: Colors.blueAccent
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),                  
                  child: Text("Add"),                  
                  onPressed: _addToDo,                  
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length ?? 0,
                itemBuilder: buildItem,              
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttomListChecked(bool check){
    if(check){
      return Icon(
        Icons.done,
        color: Colors.white,
        size: 30,
      );
    }else{
      return Icon(
        Icons.priority_high,
        color: Colors.white,
        size: 25,
      );
    }
  }

  Widget buildItem(context, index){
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),

        )
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          backgroundColor: _toDoList[index]["ok"]
            ? Colors.green
            : Colors.red,
          child: buttomListChecked(_toDoList[index]["ok"]),
        ),
        onChanged: (check){
          setState(() {
            _toDoList[index]["ok"] = check;
            _saveData();
          });
        },        
      ),
      onDismissed: (direction){
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedIndex = index;
          _toDoList.removeAt(index);
          _saveData();          

          final snack = SnackBar(
            content: Text("ToDo ${_lastRemoved["title"]} removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: (){
                setState(() {
                  _toDoList.insert(_lastRemovedIndex, _lastRemoved); 
                  _saveData();                 
                });
              }
            ),
            duration: Duration(seconds: 4),
          );

          Scaffold.of(context).showSnackBar(snack);

          // Flushbar(
          //   title: 'Erro',
          //   icon: Icon(Icons.cached),
          //   message: 'Desfazer',
          //   backgroundColor: Colors.green,
          //   mainButton: FlatButton(
          //     onPressed: (){
          //       setState(() {
          //         _toDoList.insert(_lastRemovedIndex, _lastRemoved); 
          //         _saveData();                 
          //       });
          //     },
          //     child: Text("sim!")
          //   ),
          //   duration: Duration(seconds: 4),
          // )..show(context);

        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

}
