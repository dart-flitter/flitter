import 'dart:async';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:flitter/theme.dart';
import 'routes.dart';

Future main() async {
  runApp(new Splash());

  // TODO: do stuffs like getting token, user, cache ...

//  Token token = await getToken("26258fa3ccd13c487dd8b5ed7e2acbeb087d14eb",
//      "9c2239a87cfcf51d43c2abb30eae7e1878e5f268");
//  GitterApi gApi = new GitterApi(token);
//  List<Room> rooms = await gApi.user.me.rooms();
//  print(rooms);
//  User user = await gApi.user.me.get();
//  print(user);

  runApp(new Main());
}

class Main extends StatelessWidget {
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
