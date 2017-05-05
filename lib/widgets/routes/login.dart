library flitter.routes.login;

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/auth.dart';
import 'package:flitter/theme.dart';

typedef void OnLoginCallback(GitterToken token);

class LoginView extends StatefulWidget {
  final OnLoginCallback onLogin;

  LoginView({this.onLogin});

  static void go(BuildContext context) {
    App.of(context).onLogout();
  }

  @override
  _LoginViewState createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _loggedIn;

  @override
  void initState() {
    super.initState();
    _loggedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) {
      auth().then((token) {
        if (token == null) {
          setState(() {
            _loggedIn = false;
          });
        } else {
          widget.onLogin(token);
          setState(() {
            _loggedIn = true;
          });
        }
      }).catchError(() {
        setState(() {
          _loggedIn = false;
        });
      });
    }
    return new Splash();
  }
}
