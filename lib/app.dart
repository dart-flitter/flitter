library flitter.app;

import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/routes.dart';
import 'package:flitter/theme.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          body: new Center(
            child: new CircularProgressIndicator(),
          ),
        ),
        theme: kTheme);
  }
}

class App extends StatefulWidget {
  final GitterApi api;
  App(this.api);

  @override
  AppState createState() => new AppState(api);

  static AppState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<AppState>());
}

class AppState extends State<App> {
  GitterApi api;
  List<Room> rooms;
  List<Group> groups;
  User user;

  AppState(this.api);

  @override
  void initState() {
    super.initState();
    rooms = [];
    groups = null;
  }

  Widget getRoomsAndBuildHome(BuildContext context) {
    return new FutureBuilder<List<Room>>(
      future: widget.api.user.me.rooms(),
      builder: (BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return new Splash();
        }
        rooms = snapshot.data;
        return new HomeView();
      },
    );
  }

  void onLogout() {
    setState(() {
      api = null;
      user = null;
      rooms = [];
      groups = null;
    });
  }

  _onLogin(GitterToken token) async {
    if (token != null) {
      final GitterApi _api = new GitterApi(token);
      final List<Room> _rooms = await _api.user.me.rooms();
      final User _user = await _api.user.me.get();
      setState(() {
        this.rooms = _rooms;
        this.api = _api;
        this.user = _user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (api != null && rooms.isEmpty) {
      home = getRoomsAndBuildHome(context);
    } else if (api != null && rooms.isNotEmpty) {
      home = new HomeView();
    } else {
      home = new LoginView(onLogin: _onLogin);
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
}
