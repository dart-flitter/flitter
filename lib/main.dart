import 'package:flutter/material.dart';
import 'package:flitter/common/theme.dart';
import 'routes.dart';

void main() {
  runApp(new Splash());

  // TODO: do stuffs like getting token, user, cache ...

  runApp(new Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(routes: kRoutes, theme: kTheme);
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
