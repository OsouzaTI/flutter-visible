class DChapters {
  List<String> links;

  DChapters.fromJson(dynamic json){
    links = new List<String>();
    json['mangas'].forEach((c)=>links.add(c));
  }

}