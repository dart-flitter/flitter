library flitter.app;

import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/routes.dart';
import 'package:flitter/theme.dart';

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

  void onLogin(List<Room> rooms, GitterApi api, User user) {
    setState(() {
      this.rooms = rooms;
      this.api = api;
      this.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (api != null && rooms.isEmpty) {
      home = getRoomsAndBuildHome(context);
    } else if (widget.api != null && rooms.isNotEmpty) {
      home = new HomeView();
    } else {
      home = new LoginView();
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
