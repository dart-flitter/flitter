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
  if (await isAuth()) {
    final GitterToken token = await getSavedToken();
    api = new GitterApi(token);
  }

  runApp(new App(api));
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }
}

class App extends StatefulWidget {
  GitterApi api;

  App(this.api);

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  bool isLoading;
  List<Room> rooms;

  @override
  void initState() {
    super.initState();
    rooms = [];
    isLoading = false;
  }

  Future<Null> _onTapLoginButton(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final GitterToken token = await auth();
    final GitterApi _api = new GitterApi(token);
    final List<Room> _rooms = await _api.user.me.rooms();
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = false;
      rooms = _rooms;
      config.api = _api;
    });
  }

  Widget getRoomsAndBuidlHome(BuildContext context) {
    return new FutureBuilder<List<Room>>(
      future: config.api.user.me.rooms(),
      builder: (BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return new Splash();
        }
        rooms = snapshot.data;
        return new HomeView(api: config.api, rooms: rooms);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginView loginView =
        new LoginView(onLogin: () => _onTapLoginButton(context));

    Widget home;
    if (config.api != null && rooms.isEmpty) {
      home = getRoomsAndBuidlHome(context);
    } else if (config.api != null && rooms.isNotEmpty) {
      home = new HomeView(api: config.api, rooms: rooms);
    } else {
      home = loginView;
    }

    return new MaterialApp(
      theme: kTheme,
      title: "Flitter",
      routes: {
        LoginView.path: (BuildContext context) => loginView,
        HomeView.path: (BuildContext context) =>
            new HomeView(api: config.api, rooms: rooms),
        PeopleView.path: (BuildContext context) =>
            new PeopleView(config.api, rooms),
      },
      home: isLoading ? new Splash() : home,
    );
  }
}
