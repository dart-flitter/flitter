library flitter.routes.login;

import 'dart:io';
import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/auth.dart';
import 'package:flitter/theme.dart';

typedef void OnLoginCallback(GitterToken token);

class LoginView extends StatefulWidget {
  LoginView();

  static void go(BuildContext context) {
    flitterStore.dispatch(new LogoutAction());
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
          gitterStore.dispatch(new InitGitterAction(new GitterApi(token)));
          setState(() {
            _loggedIn = true;
          });
        }
      });
    }
    return new Splash();
  }
}
