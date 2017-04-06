import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flitter/theme.dart';
import 'routes.dart';
import 'auth.dart';

Future main() async {
  runApp(new Splash());

  await auth();

  runApp(new App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(routes: kRoutes, theme: kTheme, title: "Flitter");
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            body: new Container(
                child: new Center(child: new CircularProgressIndicator()))),
        theme: kTheme);
  }
}
