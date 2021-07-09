import 'package:mobx/mobx.dart';
part 'main_model.g.dart';

class MainModel = _MainModelBase with _$MainModel;

abstract class _MainModelBase with Store {

  @observable
  Map<String, Function> handlerAnimeFunctions = Map();

  _MainModelBase();

  @action
  setHandlerAnimeFunctions(Map<String, Function> value) => handlerAnimeFunctions = value;

}