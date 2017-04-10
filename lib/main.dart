library flitter;

import 'dart:async';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'app.dart';

import 'auth.dart';

Future main() async {
  GitterApi api;
  if (await isAuth()) {
    final GitterToken token = await getSavedToken();
    api = new GitterApi(token);
  }

  runApp(new App(api));
}
