library flitter.app;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flitter/auth.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/widgets/routes/group_room.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/login.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
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

  StreamSubscription _subscription;

  AppState() {
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
    if (!gitterStore.state.init) {
      _initGitter();
      return new Splash();
    }

    if (gitterApi == null) {
      return new LoginView();
    }

    _initApp();
    Widget home = new HomeView();

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
    if (flitterStore.state.user == null) {
      User user = await gitterApi.user.me.get();
      flitterStore.dispatch(new LoginAction(user));
    }
    if (flitterStore.state.groups == null) {
      List<Group> groups = await gitterApi.group.get();
      flitterStore.dispatch(new FetchGroupsAction(groups));
    }
  }

  _initGitter() async {
    final GitterToken token = await _getSavedToken();
    if (token != null) {
      final GitterApi api = new GitterApi(token);
      gitterStore.dispatch(new AuthGitterAction(api));
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
