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
  GitterApi api;

  App(this.api);

  @override
  AppState createState() => new AppState();

  static AppState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<AppState>());
}

class AppState extends State<App> {
  GitterApi get api => config.api;
  bool isLoading;
  List<Room> rooms;
  List<Group> groups;
  User user;

  AppState();

  @override
  void initState() {
    super.initState();
    rooms = [];
    groups = null;
    isLoading = false;
  }

  Widget getRoomsAndBuildHome(BuildContext context) {
    return new FutureBuilder<List<Room>>(
      future: config.api.user.me.rooms(),
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
      config.api = null;
      user = null;
      rooms = [];
      groups = null;
    });
  }

  void loading(bool state) {
    isLoading = state;
  }

  void onLogin(List<Room> rooms, GitterApi api, User user) {
    setState(() {
      isLoading = false;
      this.rooms = rooms;
      config.api = api;
      this.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (api != null && rooms.isEmpty) {
      home = getRoomsAndBuildHome(context);
    } else if (config.api != null && rooms.isNotEmpty) {
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
      },
      home: isLoading ? new Splash() : home,
    );
  }
}
