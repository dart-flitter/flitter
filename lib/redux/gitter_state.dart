import 'package:flitter/services/gitter/gitter.dart';

class GitterState {
  final GitterApi api;
  final bool init;

  GitterState({this.api, this.init});

  GitterState.initial()
      : api = null,
        init = false;

  GitterState apply({GitterApi api, bool init}) {
    return new GitterState(api: api ?? this.api, init: init ?? this.init);
  }
}
