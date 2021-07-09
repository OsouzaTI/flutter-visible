import 'package:mobx/mobx.dart';

part 'main_model.g.dart';

class MainModel = _MainModelBase with _$MainModel;
abstract class _MainModelBase with Store {

  @observable
  Map<String, dynamic> groupChannels = Map();

  @action
  setGroupChannels(Map<String, dynamic> group) => groupChannels = group;

  @computed
  Map<String, dynamic> get getGroupChannels => groupChannels;

}