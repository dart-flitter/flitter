library flitter.app;

import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_auth.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flitter/widgets/routes/group.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/login.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flitter/widgets/routes/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appName = "Flitter";

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            body: new Column(children: [
          new Center(
              child: new FlutterLogo(
                  colors: themeStore?.state?.theme?.accentColor ?? Colors.pink,
                  size: 80.0)),
          new Center(
              child: new Text(appName, style: new TextStyle(fontSize: 32.0))),
          new Center(
              child:
                  new Text("for Gitter", style: new TextStyle(fontSize: 16.0)))
        ], mainAxisAlignment: MainAxisAlignment.center)),
        theme: themeStore?.state?.theme);
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
  var _subscription;
  var _themeSubscription;

  _AppState() {
    _subscription = gitterStore.onChange.listen((_) async {
      setState(() {});
    });
    _themeSubscription = themeStore.onChange.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _themeSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (gitterApi == null || gitterToken == null) {
      return new LoginView();
    }

    return new MaterialApp(
        theme: themeStore.state.theme,
        title: appName,
        routes: {
          HomeView.path: (BuildContext context) => new HomeView(),
          PeopleView.path: (BuildContext context) => new PeopleView(),
          GroupView.path: (BuildContext context) => new GroupView(),
          SettingsView.path: (BuildContext context) => new SettingsView()
        });
  }
}

Future run() async {
  runApp(new Splash());

  await _init();

  runApp(new App());
}

Future<Null> _init() async {
  gitterStore = new GitterStore();
  themeStore = new ThemeStore();
  final token = await FlitterAuth.getToken();
  if (token != null) {
    await initStores(token);
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool bright = prefs.getBool(ThemeState.kBrightnessKey);
  int primary = prefs.getInt(ThemeState.kPrimaryColorKey);
  int accent = prefs.getInt(ThemeState.kAccentColorKey);

  themeStore.dispatch(new ChangeThemeAction(
      brightness: bright == true ? Brightness.dark : Brightness.light,
      primaryColor:
          primary != null && primary >= 0 && primary > Colors.primaries.length
              ? Colors.primaries[primary]
              : null,
      accentColor:
          accent != null && accent >= 0 && accent > Colors.accents.length
              ? Colors.accents[accent]
              : null));
}
