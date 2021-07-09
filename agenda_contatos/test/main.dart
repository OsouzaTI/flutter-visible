import 'package:agenda_contatos/helpers/contact_helper.dart';

Contact contact;

void main(List<String> args) {
  contact.name = "Kevin";
  contact.email = "kv.willyn@gamil.com";
  contact.img = "images/teste";
  contact.phone = "24242424";

  print(contact.toMap());

}