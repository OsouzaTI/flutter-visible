import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/screens/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderContact { order_az, order_za }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper _contactHelper = ContactHelper();

  List<Contact> contacts = List();
  bool _isLoading = false;

  _handlerChangeIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    // Contact c = Contact();
    // c.name = "Ozéias";
    // c.email = "o.souzati@gmail.com";
    // c.phone = "09789897";
    // c.img = "imagem/teste";

    // _contactHelper.saveContact(c);
    _handlerChangeIsLoading();
    _handlerListAllContacts();
  }

  _handlerSaveNewContact(Contact contact) async =>
      await _contactHelper.saveContact(contact);

  _handlerUpdateContact(Contact contact) async =>
      await _contactHelper.updateContact(contact);

  _handlerListAllContacts() {
    _contactHelper.getAllContacts().then((value) {
      setState(() {
        contacts = value;
        _handlerChangeIsLoading();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),        
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderContact>(
            itemBuilder: (context) => <PopupMenuEntry<OrderContact>>[
              const PopupMenuItem<OrderContact>(
                child: Text("Ordenar A-Z"),
                value: OrderContact.order_az,
              ),
              const PopupMenuItem<OrderContact>(
                child: Text("Ordenar Z-A"),
                value: OrderContact.order_za,
              ),
            ],
            onSelected: _orderContacts,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),        
        onPressed: _showContactPage,
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: contacts.length ?? 0,
          itemBuilder: (context, index) => cardContact(contacts[index], index),
        ),
      ),
    );
  }

  Widget cardContact(Contact contact, int index) {
    double imageSize = 80;
    return GestureDetector(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(imageSize / 2)),
                      child: contact.img != null
                          ? Image.file(
                              File(contact.img),
                              fit: BoxFit.cover,
                            )
                          : Image.asset("images/person.jpeg")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.name ?? '',
                          style: TextStyle(                              
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text(contact.email ?? ''),
                      Text(contact.phone ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onLongPress: () => _showOptions(
            context, contact, index) //_showContactPage(contact: contact),
        );
  }

  void _showOptions(context, Contact contact, index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FlatButton(
                          onPressed: () {
                            launch("tel:${contact.phone}");
                          },
                          child: Text(
                            "Ligar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          )),
                      FlatButton(
                          onPressed: () {
                            _showContactPage(contact: contact);
                          },
                          child: Text(
                            "Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          )),
                      FlatButton(
                          onPressed: () {
                            _contactHelper.deleteContact(contact.id);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            "Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          )),
                    ],
                  ),
                );
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    final Contact recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    // print(recContact.toMap());

    if (recContact != null) {
      if (contact != null)
        _handlerUpdateContact(recContact);
      else
        _handlerSaveNewContact(recContact);

      _handlerListAllContacts();
    }
  }

  void _orderContacts(OrderContact value) {

    switch(value){
      case OrderContact.order_az:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      break;
      case OrderContact.order_za:
        contacts.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
      break;
    }
    setState(() {});
  }
}

// MODO ANTIGO DE FAZER UMA IMAGEM CIRCULAR
// Container(
//   width: 80,
//   height: 80,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     image: DecorationImage(
//       image: contact.img != null
//         ? FileImage(File(contact.img))
//         : AssetImage("images/person.jpeg")
//     )
//   ),
// ),
