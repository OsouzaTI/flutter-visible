// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainModel on _MainModelBase, Store {
  Computed<Map<String, dynamic>> _$getGroupChannelsComputed;

  @override
  Map<String, dynamic> get getGroupChannels => (_$getGroupChannelsComputed ??=
          Computed<Map<String, dynamic>>(() => super.getGroupChannels,
              name: '_MainModelBase.getGroupChannels'))
      .value;

  final _$groupChannelsAtom = Atom(name: '_MainModelBase.groupChannels');

  @override
  Map<String, dynamic> get groupChannels {
    _$groupChannelsAtom.reportRead();
    return super.groupChannels;
  }

  @override
  set groupChannels(Map<String, dynamic> value) {
    _$groupChannelsAtom.reportWrite(value, super.groupChannels, () {
      super.groupChannels = value;
    });
  }

  final _$_MainModelBaseActionController =
      ActionController(name: '_MainModelBase');

  @override
  dynamic setGroupChannels(Map<String, dynamic> group) {
    final _$actionInfo = _$_MainModelBaseActionController.startAction(
        name: '_MainModelBase.setGroupChannels');
    try {
      return super.setGroupChannels(group);
    } finally {
      _$_MainModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
groupChannels: ${groupChannels},
getGroupChannels: ${getGroupChannels}
    ''';
  }
}
