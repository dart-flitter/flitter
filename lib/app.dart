library flitter.app;

import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_auth.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/routes/group_room.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/login.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/theme.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            body: new Column(children: [
          new Center(child: new FlutterLogo(colors: Colors.pink, size: 80.0)),
          new Center(
              child: new Text("Flitter", style: new TextStyle(fontSize: 32.0))),
          new Center(
              child:
                  new Text("for Gitter", style: new TextStyle(fontSize: 16.0)))
        ], mainAxisAlignment: MainAxisAlignment.center)),
        theme: kTheme);
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      new Center(child: new CircularProgressIndicator());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  StreamSubscription _subscription;

  _AppState() {
    _subscription = flitterStore.onChange.listen((_) {
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
    if (gitterApi == null || gitterToken == null) {
      return new LoginView();
    }

    return new MaterialApp(theme: kTheme, title: "Flitter", routes: {
      HomeView.path: (BuildContext context) => new HomeView(),
      PeopleView.path: (BuildContext context) => new PeopleView(),
      GroupRoomView.path: (BuildContext context) => new GroupRoomView(),
    });
  }
}

Future run() async {
  runApp(new Splash());

  await _init();

  runApp(new App());
}

Future<Null> _init() async {
  final GitterToken token = await FlitterAuth.getToken();
  if (token != null) {
    flitterStore.dispatch(new AuthGitterAction(token));
    await initBasicData();
  }
}
