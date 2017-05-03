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
    store.dispatch(new LogoutAction());
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

  _fetchData(GitterToken token) {
    if (token != null) {
      final GitterApi api = new GitterApi(token);
      api.user.me.get().then((User user) {
        store.dispatch(new LoginAction(api, user));
      });
      api.user.me.rooms().then((List<Room> rooms) {
        store.dispatch(new FetchRoomsAction(rooms));
      });
      api.group.get().then((List<Group> groups) {
        store.dispatch(new FetchGroupsAction(groups));
      });
    }
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
          _fetchData(token);
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
