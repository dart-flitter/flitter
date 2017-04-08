import 'dart:async';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/routes/login.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/theme.dart';

import 'auth.dart';

Future main() async {
  GitterApi api;
  List<Room> rooms;
  if (await isAuth()) {
    final GitterToken token = await getSavedToken();
    api = new GitterApi(token);
    rooms = await api.user.me.rooms();
  }

  runApp(new App(api, rooms));
}

class App extends StatefulWidget {
  GitterApi api;
  List<Room> rooms;

  App(this.api, this.rooms);

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  Future<Null> _onTapLoginButton(BuildContext context) async {
    final GitterToken token = await auth();
    final GitterApi _api = new GitterApi(token);
    final List<Room> _rooms = await _api.user.me.rooms();
    if (!mounted) {
      return;
    }
    setState(() {
      config.rooms = _rooms;
      config.api = _api;
    });
    Navigator.pushReplacementNamed(context, HomeView.path);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: kTheme,
      title: "Flitter",
      routes: {
        LoginView.path: (BuildContext context) =>
            new LoginView(onLogin: () => _onTapLoginButton(context)),
        HomeView.path: (BuildContext context) =>
            new HomeView(config.api, config.rooms),
        PeopleView.path: (BuildContext context) => new PeopleView(
            config.api, config.rooms.where((Room room) => room.oneToOne)),
//        RoomView.path: (BuildContext context) => new RoomView(),
      },
    );
  }
}
