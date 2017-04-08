import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/routes/login.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flitter/widgets/routes/room.dart';
import 'package:flutter/material.dart';
import 'package:flitter/theme.dart';

import 'auth.dart';

Future main() async {
  GitterToken token;
  if (await isAuth()) {
    token = await getSavedToken();
  }

  runApp(new App(token));
}

class App extends StatefulWidget {
  GitterToken token;

  App(this.token);

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  GitterApi api;
  List<Room> rooms;

  Future<Null> _initState() async {
    if (config.token != null) {
      GitterApi _api = new GitterApi(config.token);
      List<Room> _rooms = await _api.user.me.rooms();
      sortRooms(_rooms);
      if (!mounted) {
        return;
      }
      setState(() {
        rooms = _rooms;
        api = _api;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<Null> _onTapLoginButton() async {
    GitterToken _token = await auth();
    GitterApi _api = new GitterApi(_token);
    List<Room> _rooms = await _api.user.me.rooms();
    sortRooms(_rooms);
    if (!mounted) {
      return;
    }
    setState(() {
      config.token = _token;
      rooms = _rooms;
      api = _api;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget home;
    LoginView loginView = new LoginView(onLogin: _onTapLoginButton);
    HomeView homeView = new HomeView(api, rooms);

    if (config.token == null) {
      home = loginView;
    } else {
      home = homeView;
    }

    return new MaterialApp(
      theme: kTheme,
      title: "Flitter",
      routes: {
        LoginView.path: (BuildContext context) => loginView,
        HomeView.path: (BuildContext context) => homeView,
        PeopleView.path: (BuildContext context) =>
            new PeopleView(api, rooms.where((Room room) => room.oneToOne)),
        RoomView.path: (BuildContext context) => new RoomView(null),
      },
      home: home,
    );
  }
}
