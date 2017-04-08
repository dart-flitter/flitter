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

  @override
  void initState() {
    super.initState();
    if (config.token != null) {
      GitterApi _api = new GitterApi(config.token);
      _api.user.me.rooms().then((List<Room> _rooms) {
        _rooms.removeWhere((Room room) => room.lastAccessTime == null);
        sortRooms(_rooms);
        setState(() {
          rooms = _rooms;
          api = _api;
        });
      });
    }
  }

  _onTapLoginButton() async {
    GitterToken _token = await auth();
    GitterApi _api = new GitterApi(_token);
    List<Room> _rooms = await _api.user.me.rooms();
    sortRooms(_rooms);
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
