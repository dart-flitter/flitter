library flitter.redux.store;

import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_reducer.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/redux/gitter_state.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:redux/redux.dart' as redux;
import 'package:flitter/redux/gitter_reducer.dart';

class FlitterStore extends redux.Store<FlitterAppState, FlitterAction> {
  FlitterStore()
      : super(new FlitterAppReducer(),
            initialState: new FlitterAppState.initial(),
            middleware: [new FlitterLoggingMiddleware()]);
}

final flitterStore = new FlitterStore();

class GitterStore extends redux.Store<GitterState, FlitterAction> {
  GitterStore()
      : super(new GitterReducer(),
            initialState: new GitterState.initial(),
            middleware: [new GitterLoggingMiddleware()]);
}

final gitterStore = new GitterStore();

GitterApi get gitterApi => gitterStore.state.api;
