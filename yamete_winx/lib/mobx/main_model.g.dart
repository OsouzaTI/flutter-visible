// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainModel on _MainModelBase, Store {
  Computed<bool> _$animationComputed;

  @override
  bool get animation =>
      (_$animationComputed ??= Computed<bool>(() => super.animation,
              name: '_MainModelBase.animation'))
          .value;

  final _$currentApiAtom = Atom(name: '_MainModelBase.currentApi');

  @override
  String get currentApi {
    _$currentApiAtom.reportRead();
    return super.currentApi;
  }

  @override
  set currentApi(String value) {
    _$currentApiAtom.reportWrite(value, super.currentApi, () {
      super.currentApi = value;
    });
  }

  final _$handlerDropDownAtom = Atom(name: '_MainModelBase.handlerDropDown');

  @override
  Map<String, Function> get handlerDropDown {
    _$handlerDropDownAtom.reportRead();
    return super.handlerDropDown;
  }

  @override
  set handlerDropDown(Map<String, Function> value) {
    _$handlerDropDownAtom.reportWrite(value, super.handlerDropDown, () {
      super.handlerDropDown = value;
    });
  }

  final _$handlerSearchAtom = Atom(name: '_MainModelBase.handlerSearch');

  @override
  Map<String, Function> get handlerSearch {
    _$handlerSearchAtom.reportRead();
    return super.handlerSearch;
  }

  @override
  set handlerSearch(Map<String, Function> value) {
    _$handlerSearchAtom.reportWrite(value, super.handlerSearch, () {
      super.handlerSearch = value;
    });
  }

  final _$isManhwaAtom = Atom(name: '_MainModelBase.isManhwa');

  @override
  bool get isManhwa {
    _$isManhwaAtom.reportRead();
    return super.isManhwa;
  }

  @override
  set isManhwa(bool value) {
    _$isManhwaAtom.reportWrite(value, super.isManhwa, () {
      super.isManhwa = value;
    });
  }

  final _$scrollAnimationAtom = Atom(name: '_MainModelBase.scrollAnimation');

  @override
  bool get scrollAnimation {
    _$scrollAnimationAtom.reportRead();
    return super.scrollAnimation;
  }

  @override
  set scrollAnimation(bool value) {
    _$scrollAnimationAtom.reportWrite(value, super.scrollAnimation, () {
      super.scrollAnimation = value;
    });
  }

  final _$_MainModelBaseActionController =
      ActionController(name: '_MainModelBase');

  @override
  dynamic setCurrentApi(String api) {
    final _$actionInfo = _$_MainModelBaseActionController.startAction(
        name: '_MainModelBase.setCurrentApi');
    try {
      return super.setCurrentApi(api);
    } finally {
      _$_MainModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setHandlerDropDown(Map<String, Function> value) {
    final _$actionInfo = _$_MainModelBaseActionController.startAction(
        name: '_MainModelBase.setHandlerDropDown');
    try {
      return super.setHandlerDropDown(value);
    } finally {
      _$_MainModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setHandlerSearch(Map<String, Function> value) {
    final _$actionInfo = _$_MainModelBaseActionController.startAction(
        name: '_MainModelBase.setHandlerSearch');
    try {
      return super.setHandlerSearch(value);
    } finally {
      _$_MainModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsManhua(bool manhwa) {
    final _$actionInfo = _$_MainModelBaseActionController.startAction(
        name: '_MainModelBase.setIsManhua');
    try {
      return super.setIsManhua(manhwa);
    } finally {
      _$_MainModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setScrollAnimation(bool animation) {
    final _$actionInfo = _$_MainModelBaseActionController.startAction(
        name: '_MainModelBase.setScrollAnimation');
    try {
      return super.setScrollAnimation(animation);
    } finally {
      _$_MainModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentApi: ${currentApi},
handlerDropDown: ${handlerDropDown},
handlerSearch: ${handlerSearch},
isManhwa: ${isManhwa},
scrollAnimation: ${scrollAnimation},
animation: ${animation}
    ''';
  }
}
