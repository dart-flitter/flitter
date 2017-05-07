library flitter.redux.reducer;

import 'package:flitter/redux/gitter_state.dart';
import 'package:flutter/material.dart';
import 'package:flitter/redux/actions.dart';
import 'package:redux/redux.dart' as redux;

class GitterLoggingMiddleware
    implements redux.Middleware<GitterState, FlitterAction> {
  call(redux.Store<GitterState, FlitterAction> store, FlitterAction action,
      next) {
    debugPrint('${new DateTime.now()}: $action');
    next(action);
  }
}

class GitterReducer extends redux.Reducer<GitterState, FlitterAction> {
  final _mapper = const <Type, Function>{
    LogoutAction: _logout,
    AuthGitterAction: _initGitter,
    InitAppAction: _initApp
  };

  @override
  GitterState reduce(GitterState state, FlitterAction action) {
    Function reducer = _mapper[action.runtimeType];
    return reducer != null ? reducer(state, action) : state;
  }
}

GitterState _logout(GitterState state, LogoutAction action) {
  return state.apply(api: null);
}

GitterState _initApp(GitterState state, InitAppAction action) {
  return state.apply(init: true);
}

GitterState _initGitter(GitterState state, AuthGitterAction action) {
  return state.apply(api: action.api);
}
