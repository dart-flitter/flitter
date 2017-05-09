library flitter;

import 'dart:async';

import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_auth.dart';
import 'package:flitter/services/flitter_config.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flitter/services/gitter/src/models/token.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';

Future main() async {
  runApp(new Splash());

  await _init();

  runApp(new App());
}

Future<Null> _init() async {
  final GitterToken token = await FlitterAuth.getToken();
  if (token != null) {
    flitterStore.dispatch(new AuthGitterAction(token));
    await initBasicData();
  }
  await flitterConfig.init();
}
