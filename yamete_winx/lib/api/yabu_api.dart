import 'package:dio/dio.dart';
import 'package:yamete_winx/models/chapters_model.dart';
import 'package:yamete_winx/models/manga_model.dart';
import 'package:yamete_winx/models/page_models.dart';

class YabuAPI {

  static Future<MangaModel> getAllChapters() async {    
    final endPoint = "https://yamete-manga.herokuapp.com/listar";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return MangaModel.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<ChapterModel> getAllMangaChapters(String idManga) async {    
    final endPoint = "https://yamete-manga.herokuapp.com/capitulos/$idManga";
    print(endPoint);
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return ChapterModel.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<MangaModel> getMangaSearch(String idManga) async {    
    final endPoint = "https://yamete-manga.herokuapp.com/search/$idManga";
    print(endPoint);
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return MangaModel.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

  static Future<PageModel> getAllPages(String name) async {
    final endPoint = "https://yamete-manga.herokuapp.com/ler/$name";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(endPoint);
      if(response.statusCode != 200){
        print("error 200");
        return null;
      }
      return PageModel.fromJson(response.data);
    } catch (e) {            
      return null;
    }
  }

}
