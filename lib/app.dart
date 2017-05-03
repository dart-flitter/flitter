library flitter.app;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flitter/auth.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/reducer.dart';
import 'package:flitter/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/routes.dart';
import 'package:flitter/theme.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new LoadingView(), theme: kTheme);
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
}

class App extends StatefulWidget {
  App();

  @override
  AppState createState() => new AppState();

  @deprecated
  static AppState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<AppState>());
}

class AppState extends State<App> {
  AppState();

  StreamSubscription _subscription;
  bool _init;

  @override
  void initState() {
    super.initState();

    _init = false;

    _subscription = store.onChange.listen((FlitterState state) {
      if (_init != state.init)
        setState(() {
          _init = state.init;
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget home = new LoadingView();

    if (_init == false) {
      _initGitter();
      return new Splash();
    }

    if (store.state.api != null) {
      home = new HomeView();
    } else {
      return new LoginView();
    }

    return new MaterialApp(
      theme: kTheme,
      title: "Flitter",
      routes: {
        HomeView.path: (BuildContext context) => new HomeView(),
        PeopleView.path: (BuildContext context) => new PeopleView(),
        GroupRoomView.path: (BuildContext context) =>
            new GroupRoomView(appState: App.of(context), group: null),
      },
      home: home,
    );
  }

  _initGitter() async {
    final GitterToken token = await _getSavedToken();
    store.dispatch(new InitGitterAction(new GitterApi(token)));
  }

  Future<GitterToken> _getSavedToken() async {
    File tokenFile = await getTokenFile();
    if (!await tokenFile.exists()) {
      return null;
    }
    return new GitterToken.fromJson(
        JSON.decode(await tokenFile.readAsString()));
  }
}
