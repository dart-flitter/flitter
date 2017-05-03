library flitter.redux.store;

import 'package:flitter/redux/actions.dart';
import 'package:redux/redux.dart' as redux;
import 'package:flitter/redux/reducer.dart';

class FlitterStore extends redux.Store<FlitterState, FlitterAction> {
  FlitterStore()
      : super(new FlitterReducer(),
            initialState: new FlitterState.initial(),
            middleware: [new LoggingMiddleware()]);
}

final store = new FlitterStore();
