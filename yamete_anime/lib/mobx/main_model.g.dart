// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainModel on _MainModelBase, Store {
  final _$handlerAnimeFunctionsAtom =
      Atom(name: '_MainModelBase.handlerAnimeFunctions');

  @override
  Map<String, Function> get handlerAnimeFunctions {
    _$handlerAnimeFunctionsAtom.reportRead();
    return super.handlerAnimeFunctions;
  }

  @override
  set handlerAnimeFunctions(Map<String, Function> value) {
    _$handlerAnimeFunctionsAtom.reportWrite(value, super.handlerAnimeFunctions,
        () {
      super.handlerAnimeFunctions = value;
    });
  }

  final _$_MainModelBaseActionController =
      ActionController(name: '_MainModelBase');

  @override
  dynamic setHandlerAnimeFunctions(Map<String, Function> value) {
    final _$actionInfo = _$_MainModelBaseActionController.startAction(
        name: '_MainModelBase.setHandlerAnimeFunctions');
    try {
      return super.setHandlerAnimeFunctions(value);
    } finally {
      _$_MainModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
handlerAnimeFunctions: ${handlerAnimeFunctions}
    ''';
  }
}
