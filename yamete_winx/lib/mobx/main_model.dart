import 'package:mobx/mobx.dart';
part 'main_model.g.dart';

class MainModel = _MainModelBase with _$MainModel;

abstract class _MainModelBase with Store {

  @observable
  String currentApi;

  @observable
  Map<String, Function> handlerDropDown = Map();
  
  @observable
  Map<String, Function> handlerSearch = Map();

  @observable
  bool isManhwa = false;

  @observable
  bool scrollAnimation = false;

  _MainModelBase({this.currentApi, this.handlerDropDown});

  @action
  setCurrentApi(String api) => currentApi = api;
  @action
  setHandlerDropDown(Map<String, Function> value) => handlerDropDown = value;
  @action
  setHandlerSearch(Map<String, Function> value) => handlerSearch = value;
  @action
  setIsManhua(bool manhwa) => isManhwa = manhwa;
  @action
  setScrollAnimation(bool animation) => scrollAnimation = animation;

  @computed
  bool get animation => scrollAnimation;
 

}