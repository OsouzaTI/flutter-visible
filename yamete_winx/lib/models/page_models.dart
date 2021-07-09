
class Page {

  String url;

  Page(String url){
    this.url = url;
  }

}

class PageModel {

  List<Page> pages;  

  PageModel.fromJson(dynamic json){
    // construtor da lista 
    pages = [];    
    json["mangas"].forEach((e){      
      Page page = new Page(e);
      pages.add(page);      
    });
  }


}
