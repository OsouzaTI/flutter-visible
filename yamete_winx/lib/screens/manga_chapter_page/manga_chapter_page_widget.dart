import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:yamete_winx/api/yabu_api.dart';
import 'package:yamete_winx/components/appbar/widget/dropdown_buttom/dropdown_button_widget.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppGradients.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';
import 'package:yamete_winx/main.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:yamete_winx/models/chapters_model.dart';
import 'package:yamete_winx/screens/manga_chapter_page/widgets/chapter_tile_widget.dart';
import 'package:yamete_winx/screens/manga_page/manga_page_screen.dart';
import 'package:yamete_winx/shared/loading_progress_bar.dart';
import 'package:yamete_winx/shared/snackbar_bottom.dart';
import 'package:yamete_winx/shared/switch_widget.dart';
import 'package:yamete_winx/shared/windows_buttons.dart';
import 'package:provider/provider.dart';

class MangaChapterScreen extends StatefulWidget {
  final String chapterID;
  MangaChapterScreen({Key key, this.chapterID}) : super(key: key);

  @override
  _MangaChapterScreenState createState() => _MangaChapterScreenState();
}

class _MangaChapterScreenState extends State<MangaChapterScreen> {
  bool _isLoading = false;
  bool _isFiltering = false;
  ChapterModel _chapters;
  Iterable<Chapter> _chaptersFilter;
  String _dropDownValue;
  MainModel mainModel;
  bool _isManhwa = false;

  @override
  void initState() { 
    super.initState();
    _handlerGetChapters();    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mainModel = Provider.of<MainModel>(context);
  }

  _navigationReadPage(String title, String link){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaPageScreen(name: title, link: link,)),
    );
  }

  _handlerToggleIsLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _handlerGetChapters() async {
    _handlerToggleIsLoading();
    _chapters = await YabuAPI.getAllMangaChapters(widget.chapterID);
    if(_chapters != null){      
      _handlerToggleIsLoading();
    }else{
      print("nulo");
      showOverlayNotification((_){
        return SnackBarWidget(   
          icon: Icons.error_outline,       
          title: "API error",
          message: "return null",
          color: Colors.red,
        );
      }, position: NotificationPosition.bottom);
    }
  }

  _handlerIsManhwa(){
    setState(() {
      _isManhwa = !_isManhwa;
    });
    mainModel.setIsManhua(_isManhwa);
  }

  _handlerDropDownSet(String value){
    print("Mudou doido");
    
    if(value == "00"){
      _isFiltering = false;
    }else{
      _isFiltering = true;
      _chaptersFilter = _chapters.chapters.where((e) => e.title.contains(value));
    }

    setState(() {
      _dropDownValue = value;
    });
  }

  _handlerPopNavigator(BuildContext context){
    Navigator.pop(context);
  }

  Widget listViewBuilder(List<Chapter> chapters){
    return ListView.builder(                                          
      itemCount: chapters.length,
      itemBuilder: (_, i)=>MangaChapterTileWidget(
        title:  chapters[i].title,
        link:   chapters[i].link,
        data:   chapters[i].data,
        handlerRead: _navigationReadPage,
      )
    );
  }

  List<String> getChaptersNumbers(int size){
    List<int> number = List.generate(size, (n)=>n);
    List<String> chapters = [];
    number.forEach((n) {
      if(n < 10)
        chapters.add("0$n");
      else
        chapters.add("$n");
    });
    return chapters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
          gradient: AppGradients.linear02
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              color: Colors.black,            
              child: Row(
                children: [
                  SizedBox(
                    width: 60, 
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.iconColor,),                 
                      onPressed: () => _handlerPopNavigator(context),
                    )
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: MoveWindow()
                        ),
                        WindowButtomWidget(),
                      ],
                    )
                  ),          
                ],
              ),
            ),
            Expanded(
              child:  _isLoading
              ? LoadingCircularProgressBarWidget()
              : Container(
                width: MediaQuery.of(context).size.width * 0.5,                      
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(                            
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Manhwa: ", style: AppTextStyles.dropdownHint,),
                          SwitchWidget(
                            safeMode: _isManhwa,
                            safeModeFunc: _handlerIsManhwa,
                          ),
                          DropDownButtonWidget(
                            data: getChaptersNumbers(_chapters.chapters.length),
                            label: "Pagina: ",
                            newValue: _dropDownValue,
                            handlerSetDropDown: _handlerDropDownSet,
                            icons: Icons.filter_alt_outlined
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(                            
                      height: MediaQuery.of(context).size.height * 0.70,
                      child: listViewBuilder(
                        _isFiltering
                        ? _chaptersFilter?.toList()
                        : _chapters.chapters
                      ),
                    ),
                  ],
                ),
              ),
            )

            // Expanded(
            //   child: _isLoading
            //     ? LoadingCircularProgressBarWidget()
            //     : Container(
            //       decoration: BoxDecoration(
            //         gradient: AppGradients.linear02
            //       ),
            //       child: Row(
            //         children: [
            //           Expanded(
            //             flex: 1,
            //             child: Center(
            //               child: listViewBuilder(
            //                 _isFiltering
            //                 ? _chaptersFilter?.toList()
            //                 : _chapters.chapters
            //               ),
            //             )
            //           ),
            //           Expanded(
            //             flex: 1,
            //             child: Center(
            //               child: Image.network("https://flutter.dev/images/owl.jpg"),
            //             ),
            //           )
            //         ],
            //       ),
            //     )
            // )
          ],
        ),
      ),
    );
  }
}


// Expanded(
//   flex: 1,
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Capítulo: ", style: AppTextStyles.dropdownHint,),
//           SizedBox(width: 20,),
//           DropDownButtonWidget(
//             data: getChaptersNumbers(_chapters.chapters.length),
//             label: "Pagina: ",
//             newValue: _dropDownValue,
//             handlerSetDropDown: _handlerDropDownSet,
//             icons: Icons.filter_alt_outlined
//           ),
//         ],
//       ),
//       SwitchWidget(
//         safeMode: _isManhwa,
//         safeModeFunc: _handlerIsManhwa,
//       ),
//     ],
//   )
// )