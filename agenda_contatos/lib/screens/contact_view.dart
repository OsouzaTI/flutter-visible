import 'dart:io';
import 'dart:ui';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  /* Parametro opcional usa-se {} */
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final double imageSize = 140;
  Contact _editedContact;
  bool _isChanged = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();
  File _file;

  @override
  void initState() {    
    super.initState();
    /* Contato que sera editado */
    if(widget.contact == null){
      /* Cria-se um novo contato caso o recebido seja null */
      _editedContact = Contact();
    }else{
      /* Se não, duplicare-mos o contato recebido */
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }

  }

  String _handlerValidation(String value){
    if(value.isEmpty){
      return "Campo vazio!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
            child: Scaffold(
              appBar: AppBar(                
                title: Text(_editedContact.name ?? "Novo Contato"),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save),                
                onPressed: (){
                  if(_formKey.currentState.validate()){            
                    Navigator.pop(context, _editedContact);            
                  }
                },
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(                    
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:2.0, bottom: 8.0),
                      child: GestureDetector(
                        child: SizedBox(
                          width: imageSize,
                          height: imageSize,
                          child: ClipRRect( 
                            borderRadius: BorderRadius.all(Radius.circular(imageSize/2)),                       
                            child: _editedContact.img != null
                              ? Image.file(
                                File(_editedContact.img),
                                fit: BoxFit.cover,
                              )
                              : Image.asset("images/person.jpeg")
                          ),
                        ),
                        onTap: () async {
                          final _pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
                          if(_pickedFile != null){
                            _file = File(_pickedFile.path);
                          }else {
                            print('No image selected.');
                          }
                          
                          setState(() {
                            _editedContact.img = _file.path;
                          });
                        },
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _nameController,
                              validator: _handlerValidation,                                                            
                              decoration: _inputDecoration("Nome"),
                              onChanged: (value){
                                _isChanged = true;
                                setState(() {
                                  _editedContact.name = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: _inputDecoration("Email"),
                              onChanged: (value){
                                _isChanged = true;
                                _editedContact.email = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _phoneController,
                              validator: _handlerValidation,
                              decoration: _inputDecoration("Phone"),
                              onChanged: (value){
                                _isChanged = true;
                                _editedContact.phone = value;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                          ),
      
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      
        InputDecoration _inputDecoration(String label){
          return InputDecoration(
            labelText: label,
            // hintText: label,
            alignLabelWithHint: true,
          );
        }
      
      
  Future<bool> _requestPop() {

    if(_isChanged){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar as Alterações?"),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancelar")
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Sim")
              ),
            ],
          );
        }
      );

      return Future.value(false);

    } else {

      return Future.value(true);
      
    }

  }
}