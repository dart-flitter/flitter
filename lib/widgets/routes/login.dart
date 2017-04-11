import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/auth.dart';

class LoginView extends StatefulWidget {
  static void go(BuildContext context) {
    App.of(context).onLogout();
  }

  @override
  _LoginViewState createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Future<Null> _onTapLoginButton(BuildContext context) async {
    AppState appState = App.of(context);

    appState.loading(true);
    final GitterToken token = await auth();
    final GitterApi _api = new GitterApi(token);
    final List<Room> _rooms = await _api.user.me.rooms();
    final User _user = await _api.user.me.get();
    if (!mounted) {
      return;
    }
    appState.onLogin(_rooms, _api, _user);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: [
          new Expanded(
            child: new Center(
              child: new Text(
                "Flitter",
                style: new TextStyle(fontSize: 70.0, color: Colors.pink),
              ),
            ),
          ),
          new Expanded(
            child: new Center(
              child: new RaisedButton(
                color: Colors.pink,
                child: new Text(
                  "Login",
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _onTapLoginButton(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
