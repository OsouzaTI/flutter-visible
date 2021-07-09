import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_query.dart';

final String idColumn     = "idColumn";
final String nameColumn   = "nameColumn";
final String emailColumn  = "emailColumn";
final String phoneColumn  = "phoneColumn";
final String imgColumn    = "imgColumn";
final String contactTable = "contactTable";

/* Padrão Singleton */

/* Só existirá um objeto dessa classe em todo o codigo */
class ContactHelper {
  
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  DBquery _query = DBquery();
  Database _db;

  get db async {
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  /*===================
  Data base functions
  ===================*/ 

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreateDb,
    );

  }

  /* this method is called every time the database created */
  onCreateDb(Database db, int version) async {

    Map<String, String> colunas = new Map();
    colunas[idColumn]     = "INTEGER PRIMARY KEY";
    colunas[nameColumn]   = "TEXT";
    colunas[emailColumn]  = "TEXT";
    colunas[phoneColumn]  = "TEXT";
    colunas[imgColumn]    = "TEXT";

    /* Create a table using the global Database _db */
    await db.execute(_query.createTable(contactTable, colunas));
    
  }

  /* this method is called whenever a database update occurs */
  onUpdateDb(Database db, int versio) async {


  }

  /*===================
  Data controll in DataBase functions
  ===================*/ 

  Future<Contact> saveContact(Contact contact) async {
    print("OLHA AI $contact");
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    print("Contato salvo com ID: ${contact.id}");
    return contact;

  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(
      contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]
    );

    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    }

    return null;
  }

  Future<int> deleteContact(int id) async {

    Database dbContact = await db;
    return await dbContact.delete(
      contactTable,
      where: "$idColumn = ?",
      whereArgs: [id]
    );

  }

  Future<int> updateContact(Contact contact) async {
    
    Database dbContact = await db;
    return await dbContact.update(
      contactTable,
      contact.toMap(),
      where: "$idColumn = ?",
      whereArgs: [contact.id]
    );

  }

  Future<List<Contact>> getAllContacts() async {
     
    Database dbContact = await db;

    List listMap = await dbContact.rawQuery(
      _query.selectAll(contactTable)
    );

    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }

    return listContact;

  }

  Future<int> getDataBaseLenght() async {

    Database dbContact = await db;
    
    return Sqflite.firstIntValue(
      await dbContact.rawQuery(_query.count(contactTable))
    );

  }

  Future<Null> close() async {
    Database dbContact = await db;
    dbContact.close();
    return null;
  }

}

class Contact {

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };

    if(id != null){
      map[idColumn] = id;
    }
    return map;

  }

  @override
  String toString(){
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

}