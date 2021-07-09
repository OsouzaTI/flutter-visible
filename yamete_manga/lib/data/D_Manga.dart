class ChaptersLinks {  
  Map<int, String> links;

  ChaptersLinks.fromJson(dynamic json){
    links = new Map<int, String>();
    int index = 0;
    json['mangas'].forEach((e){
      links[index] = e;
      index++;
    });
  }

}

class DManga {
  String name;
  String img;
  String link;
  bool isFavorite;

  // Só sera usada para os favoritos
  String value;

  DManga(){
    this.name = '';
    this.img = '';
    this.link = '';
    this.isFavorite = false;
  }

}

class DataAllMangas {
  List<DManga> mangas;
  
  DataAllMangas(){
    mangas = new List<DManga>();
  }

  DataAllMangas.fromJson(dynamic json){
    mangas = new List<DManga>();
    json["mangas"].forEach((e){
      DManga temp = new DManga();
      temp.name = e['title'] ?? '';
      temp.img = e['img'] ?? '';
      temp.link = e['link'] ?? '';
      mangas.add(temp);
    });
  }

}