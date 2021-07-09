
class Manga {

  String title;
  String tag;
  String link;
  String img;
  String chapterID;

  Manga({String title, String tag, String link, String img, String chapterID}){
    this.title  = title ??'';
    this.tag    = tag   ??'';
    this.link   = link  ??'';
    this.img    = img   ??'';
    this.chapterID    = chapterID   ??'';
  }

}

class MangaModel {

  List<Manga> mangas;  

  MangaModel.fromJson(dynamic json){
    // construtor da lista 
    mangas = [];
    String _title, _tag, _link, _img, _chapterID;
    json["mangas"].forEach((e){
      _title  = e["title"];
      _tag    = e["tag"];
      _link   = e["link"];
      _img    = e["img"];      
      _chapterID = e["chapters"];      
      Manga manga = new Manga(
        title: _title,
        tag: _tag,
        link: _link,
        img: _img,
        chapterID: _chapterID
      );
      mangas.add(manga);      
    });
  }


}
