import 'package:dio/dio.dart';

class Temporada {
  String title;
  Animes animes;
  Temporada(this.title, this.animes);
}

class Temporadas {
  List<Temporada> temporadas;
  Temporadas.fromJson(dynamic json){
    temporadas = [];
    json["mangas"].forEach((e){      
      String title = e['title'];
      Animes animes = Animes.fromList(e['eps']);
      Temporada temporada = new Temporada(title, animes);
      print(e);
      temporadas.add(temporada);
    });
  }
}

class Categoria {
  String title;
  String link;
  Categoria(this.title, this.link);
}

class Categorias {
  List<Categoria> categorias;
  Categorias.fromJson(dynamic json){
    categorias = [];
    json["mangas"].forEach((e){      
      Categoria categoria = new Categoria(e['title'], e['link']);
      categorias.add(categoria);
    });
  }
}

class Anime {
  String title;
  String img;
  String link;
  Anime(this.title, this.img, this.link);
}

class Animes {
  List<Anime> animes;
  
  Animes.fromJson(dynamic json){
    animes = [];
    json["mangas"].forEach((e){      
      Anime anime = new Anime(e['title'], e['img'], e['link']);
      animes.add(anime);
    });
  }

  Animes.fromList(dynamic json){
    animes = [];
    json.forEach((e){      
      Anime anime = new Anime(e['title'], e['img'], e['link']);
      animes.add(anime);
    });
  }

  @override
  String toString() {    
    String _str = "";
    int max = 3, i = 0;
    for(i; i < max; i++){
      _str += '{';
        _str += 'title: ' + animes[i].title +',';
        _str += 'img: '   + animes[i].img   +',';
        _str += 'link: '  + animes[i].link  +',';
      _str += '},\n';
    }
    return _str;
  }

}

class AnimeAPI {

  // static String api = "http://localhost:3000";
  static String api = "http://localhost:3000/AOV";

  static Future<Animes> listarAnimes() async {    
    final endPoint = "$api/listar";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return Animes.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<Animes> listarCategoriaAnimes(String categoriaID) async {    
    final endPoint = "$api/categoria/$categoriaID";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      // print(response.data);
      return Animes.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<Animes> buscarAnimes(String categoriaID) async {    
    final endPoint = "$api/search/$categoriaID";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return Animes.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<Categorias> categoriasAnimes() async {    
    final endPoint = "$api/categorias";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return Categorias.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<Temporadas> animeTemporadas(String animeID) async {    
    final endPoint = "$api/episodios/$animeID";
    print(endPoint);
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      // print(response.data);
      return Temporadas.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<String> mediaAnime(String animeID) async {    
    final endPoint = "$api/video/$animeID";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return response.data['mangas'][0];
    } catch (e) {            
      return null;
    }
  }




}
