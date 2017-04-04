import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:flitter/theme.dart';
import 'package:flutter/services.dart';
import 'routes.dart';
import 'app_state.dart';

Future<Token> auth() async {
  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
  File tokenFile = new File("$dir/token.json");
  Token token;
  if (!tokenFile.existsSync()) {
    tokenFile.createSync();
  }
  final String content = await tokenFile.readAsString();
  if (content.isEmpty) {
    token = await getToken("26258fa3ccd13c487dd8b5ed7e2acbeb087d14eb",
        "9c2239a87cfcf51d43c2abb30eae7e1878e5f268");
    tokenFile.writeAsStringSync(JSON.encode(token.toMap()));
    return token;
  }
  return new Token.fromJson(JSON.decode(content));
}

Future main() async {
  runApp(new Splash());

  final appState = new AppState();
  appState.token = await auth();
  appState.gApi = new GitterApi(appState.token);
  appState.user = await appState.gApi.user.me.get();

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
