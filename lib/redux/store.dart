library flitter.redux.store;

import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_reducer.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:redux/redux.dart' as redux;

class FlitterStore extends redux.Store<FlitterAppState, FlitterAction> {
  FlitterStore()
      : super(new FlitterAppReducer(),
            initialState: new FlitterAppState.initial(),
            middleware: [new FlitterLoggingMiddleware()]);
}

FlitterStore flitterStore = new FlitterStore();
GitterApi get gitterApi => flitterStore.state.api;
GitterToken get gitterToken => flitterStore.state.token;
