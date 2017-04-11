library flitter;

import 'dart:async';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:flitter/auth.dart';

Future main() async {
  GitterApi api;

  runApp(new Splash());

  if (await isAuth()) {
    final GitterToken token = await getSavedToken();
    api = new GitterApi(token);
  }

  runApp(new App(api));
}
