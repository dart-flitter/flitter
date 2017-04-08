import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class LoginView extends StatelessWidget {
  static final String path = "/login";

  VoidCallback onLogin;

  LoginView({@required this.onLogin});

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
                onPressed: onLogin,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
