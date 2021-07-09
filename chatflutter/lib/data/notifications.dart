enum NotificationType {
  type_add_contact,
}

extension ParseToString on NotificationType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class Notifications {
  String type;
  String name;
  String title;
  String uid;
  String photoUrl;
  Notifications(this.type, this.name, this.title, this.uid, this.photoUrl);

  Map<String, dynamic> toMap(){
    Map<String, dynamic> temp = new Map();
    temp["type"]  = this.type;
    temp["name"]  = this.name;
    temp["title"] = this.title;
    temp["uid"] = this.uid;
    temp["photoUrl"] = this.photoUrl;
    return temp;
  }
}