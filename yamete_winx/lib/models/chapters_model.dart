
class Chapter {

  String title;
  String link;
  String data;

  Chapter(String title, String link, String data){
    this.title  = title ??'';
    this.link   = link  ??'';
    this.data   = data  ??'';
  }

}

class ChapterModel {

  List<Chapter> chapters;  

  ChapterModel.fromJson(dynamic json){
    // construtor da lista 
    chapters = [];
    String _title, _link, _data;
    json["mangas"].forEach((e){
      _title  = e["title"];
      _link   = e["link"];
      _data   = e["data"];      
      Chapter chapter = new Chapter(_title, _link, _data);
      chapters.add(chapter);      
    });
  }


}
