library flitter.app;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flitter/auth.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/gitter_reducer.dart';
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
  Widget build(BuildContext context) =>
      new Scaffold(body: new Center(child: new CircularProgressIndicator()));
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

  bool init;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    init = false;

    _subscription = gitterStore.onChange.listen((_) {
      setState(() {});
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

    if (!gitterStore.state.init) {
      _initGitter();
      return new Splash();
    }

    if (gitterApi != null) {
      _initApp();
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
          GroupRoomView.path: (BuildContext context) => new GroupRoomView(),
        },
        home: home);
  }

  _initApp() async {
    User user = await gitterApi.user.me.get();
    List<Group> groups = await gitterApi.group.get();
    flitterStore.dispatch(new LoginAction(user));
    flitterStore.dispatch(new FetchGroupsAction(groups));
  }

  _initGitter() async {
    final GitterToken token = await _getSavedToken();
    if (token != null) {
      final GitterApi api = new GitterApi(token);
      gitterStore.dispatch(new InitGitterAction(api));
    }
    gitterStore.dispatch(new InitAppAction());
  }

  Future<GitterToken> _getSavedToken() async {
    File tokenFile = await getTokenFile();
    if (!await tokenFile.exists()) {
      return null;
    }
    Map token = JSON.decode(await tokenFile.readAsString());
    if (token.isEmpty) {
      return null;
    }
    return new GitterToken.fromJson(token);
  }
}
