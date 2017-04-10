library flitter.app;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/routes/login.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:meta/meta.dart';
import 'package:flitter/theme.dart';

import 'auth.dart';

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
  AppState createState() => new AppState(api: api);
}

class AppState extends State<App> {
  final GitterApi api;
  bool isLoading;
  List<Room> rooms;
  User user;

  AppState({@required this.api});

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
    final User _user = await _api.user.me.get();
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = false;
      rooms = _rooms;
      config.api = _api;
      user = _user;
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
        return new HomeView(app: this);
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
      home = new HomeView(app: this);
    } else {
      home = loginView;
    }

    return new MaterialApp(
      theme: kTheme,
      title: "Flitter",
      routes: {
        LoginView.path: (BuildContext context) => loginView,
        HomeView.path: (BuildContext context) => new HomeView(app: this),
        PeopleView.path: (BuildContext context) => new PeopleView(app: this),
      },
      home: isLoading ? new Splash() : home,
    );
  }
}
