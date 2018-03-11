library flitter.redux.store;

import 'package:flitter/redux/flitter_app_reducer.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:gitter/gitter.dart';
import 'package:gitter/src/faye.dart';
import 'package:redux/redux.dart' as redux;

class FlitterStore extends redux.Store<FlitterAppState> {
  FlitterStore(
    {FlitterAppState initialState,
    redux.Reducer<FlitterAppState> reducer,
    List<redux.MiddlewareClass> middlewares: const [
      const FlitterLoggingMiddleware()
    ]})
      : super(reducer ?? new FlitterAppReducer(),
      initialState: initialState ?? new FlitterAppState.initial(),
      middleware: middlewares);
}

class ThemeStore extends redux.Store<ThemeState> {
  ThemeStore(
    {ThemeState initialState,
    redux.Reducer<ThemeState> reducer})
      : super(reducer ?? new ThemeReducer(),
      initialState: initialState ?? new ThemeState.initial());
}

class GitterStore extends redux.Store<GitterState> {
  GitterStore(
    {GitterState initialState,
    redux.Reducer<GitterState> reducer,
    List<redux.MiddlewareClass> middlewares: const [
      const GitterLoggingMiddleware()
    ]})
      : super(reducer ?? new GitterReducer(),
      initialState: initialState ?? new GitterState.initial(),
      middleware: middlewares);
}

FlitterStore flitterStore;
GitterStore gitterStore;
ThemeStore themeStore;

GitterApi get gitterApi => gitterStore.state.api;
GitterToken get gitterToken => gitterStore.state.token;
GitterFayeSubscriber get gitterSubscriber => gitterStore.state.subscriber;
